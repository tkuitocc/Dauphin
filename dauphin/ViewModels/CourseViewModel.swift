//
//  CourseViewModel.swift
//  campuspass_ios
//
//  Created by \u8b19 on 11/17/24.
//
import SwiftUI
import Combine

// MARK: - ViewModel for Courses
class CourseViewModel: ObservableObject {
    private let appGroupDefaults = UserDefaults(suiteName: "group.cantpr09ram.dauphin")

    @Published var weekCourses: [[Course]]
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    private var helper: CustomAES256Helper?
    var cancellables = Set<AnyCancellable>()
        
    init() {
        self.weekCourses = Array(repeating: [Course](), count: 6)
        Task {
            initializeHelper()
        }
    }
    
    init(mockData: [[Course]]) {
        self.weekCourses = mockData
    }
    
    private func initializeHelper() {
        if let key = KeychainManager.shared.get(forKey: "AES256KEY"),
           let iv = KeychainManager.shared.get(forKey: "AES256IV") {
            helper = CustomAES256Helper(key: key, iv: iv)
            print("✅ Successfully initialized helper with AES256 key and IV retrieved from Keychain.")
        } else {
            errorMessage = "Failed to retrieve AES256 key or IV from Keychain."
            print("❌ Error: \(errorMessage ?? "Unknown error")")
        }
    }
    
    func loadCoursesFromCache() -> [[Course]]? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        guard let appGroupDefaults = self.appGroupDefaults else {
            print("❌ App Group Defaults is not available.")
            return nil
        }

        if let data = appGroupDefaults.data(forKey: Constants.Courses) {
            do {
                let courses = try decoder.decode([[Course]].self, from: data)
                print("✅ Loaded courses from cache successfully!")
                return courses
            } catch {
                print("❌ Failed to decode cached courses: \(error)")
            }
        } else {
            print("❌ No data found for key: \(Constants.Courses)")
        }
        return nil
    }


    func saveCoursesToCache(courses: [[Course]]) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        guard let appGroupDefaults = self.appGroupDefaults else {
            print("App Group Defaults is not available.")
            return
        }

        do {
            let data = try encoder.encode(courses)
            appGroupDefaults.set(data, forKey: Constants.Courses)
            print("✅ Courses saved to cache successfully!")
        } catch {
            print("Failed to encode courses: \(error)")
        }
    }
    
    func fetchCourses(with stdNo: String) {
        guard let helper = helper else {
            DispatchQueue.main.async {
                self.errorMessage = "Encryption helper not initialized"
                self.isLoading = false
            }
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            guard let encrypted = helper.encrypt(data: "20220901200540356," + stdNo) else {
                DispatchQueue.main.async {
                    self.errorMessage = "Encryption failed"
                    self.isLoading = false
                }
                return
            }

            guard let q = encrypted.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to encode query parameter"
                    self.isLoading = false
                }
                return
            }

            guard let url = URL(string: "https://ilifeapi.az.tku.edu.tw/api/ilifeStuClassApi?q=\(q)") else {
                DispatchQueue.main.async {
                    self.errorMessage = "Invalid URL"
                    self.isLoading = false
                }
                return
            }

            var request = URLRequest(url: url, timeoutInterval: Double.infinity)
            request.httpMethod = "GET"

            DispatchQueue.main.async {
                self.isLoading = true
            }
            
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.errorMessage = "Request failed with error: \(error.localizedDescription)"
                    }
                    return
                }
                guard let data = data else {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.errorMessage = "No data received"
                    }
                    return
                }

                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let jsonDict = json as? [String: Any] else {
                        throw URLError(.badServerResponse)
                    }

                    let courses = self.parseCourseData(apiData: jsonDict)
                    self.saveCoursesToCache(courses: courses)

                    DispatchQueue.main.async {
                        self.weekCourses = courses
                        self.isLoading = false
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.errorMessage = "Failed to parse JSON: \(error.localizedDescription)"
                    }
                }
            }
            task.resume()
        }
    }


    private func parseCourseData(apiData: [String: Any]) -> [[Course]] {
        var weekCourses = Array(repeating: [Course](), count: 6)
        if let stuelelist = apiData["stuelelist"] as? [[String: Any]] {
            for courseData in stuelelist {
                if let weekString = courseData["week"] as? String,
                   let weekIndex = Int(weekString),
                   weekIndex >= 1, weekIndex <= 6 {
                    let name = (courseData["ch_cos_name"] as? String ?? "Unknown").replacingOccurrences(of: "\\s*\\(.*\\)", with: "", options: .regularExpression)
                    let room = courseData["room"] as? String ?? "Unknown Room"
                    let teacher = courseData["teach_name"] as? String ?? "Unknown Teacher"
                    let seat_no = courseData["seat_no"] as? String ?? "Unknown Seat"
                    if let timeSessions = courseData["timePlase"] as? [String: Any],
                       let sesses = timeSessions["sesses"] as? [String] {
                        let time = sesses.joined(separator: ", ")

                        if let firstSession = sesses.first,
                           let lastSession = sesses.last,
                           let firstSessionInt = Int(firstSession),
                           let lastSessionInt = Int(lastSession),
                           let start = sessionToStartTime(session: firstSessionInt),
                           let end = sessionToEndTime(session: lastSessionInt) {
                            
                            weekCourses[weekIndex - 1].append(
                                Course(name: name, room: room, teacher: teacher, time: time, startTime: start, endTime: end, stdNo: seat_no)
                            )
                        }
                    }
                }
            }
        }
        return weekCourses
    }

    private func sessionToStartTime(session: Int) -> Date? {
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = 1989
        components.month = 6
        components.day = 4
        components.minute = 10
        switch session {
        case 1: components.hour = 8
        case 2: components.hour = 9
        case 3: components.hour = 10
        case 4: components.hour = 11
        case 5: components.hour = 12
        case 6: components.hour = 13
        case 7: components.hour = 14
        case 8: components.hour = 15
        case 9: components.hour = 16
        case 10: components.hour = 17
        case 11: components.hour = 18
        case 12: components.hour = 19
        case 13: components.hour = 20
        case 14: components.hour = 21
        default: return nil
        }
        return calendar.date(from: components)
    }

    private func sessionToEndTime(session: Int) -> Date? {
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = 1989
        components.month = 6
        components.day = 4
        components.minute = 0
        switch session {
        case 1: components.hour = 9
        case 2: components.hour = 10
        case 3: components.hour = 11
        case 4: components.hour = 12
        case 5: components.hour = 13
        case 6: components.hour = 14
        case 7: components.hour = 15
        case 8: components.hour = 16
        case 9: components.hour = 17
        case 10: components.hour = 18
        case 11: components.hour = 19
        case 12: components.hour = 20
        case 13: components.hour = 21
        case 14: components.hour = 22
        default: return nil
        }
        return calendar.date(from: components)
    }

}
