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
    @Published var weekCourses: [[Course]]
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    private var helper: CustomAES256Helper?
    private var cancellables = Set<AnyCancellable>()
        
    init() {
        self.weekCourses = Array(repeating: [Course](), count: 5)
        Task {
            await initializeHelper()
        }
    }
    
    // Initializer for mock data
    init(mockData: [[Course]]) {
        self.weekCourses = mockData
    }
    
    private func initializeHelper() async {
        do {
            try await KeyConstants.loadAPIKeys()
        
            let key = KeyConstants.APIKeys.AES256KEY
            let iv = KeyConstants.APIKeys.AES256IV
            helper = CustomAES256Helper(key: key, iv: iv)
            print("Helper initialized with AES256 key and IV.")
        } catch {
            errorMessage = "Failed to load API keys: \(error.localizedDescription)"
            print("Error: \(errorMessage ?? "Unknown error")")
        }
    }

    func fetchCourses(with stdNo: String) {
        guard let helper = helper else {
            self.errorMessage = "Encryption helper not initialized"
            self.isLoading = false
            return
        }

        guard let encrypted = helper.encrypt(data: "20220901200540356," + stdNo) else {
            self.errorMessage = "Encryption failed"
            self.isLoading = false
            return
        }

        guard let q = encrypted.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            self.errorMessage = "Failed to encode query parameter"
            self.isLoading = false
            return
        }

        guard let url = URL(string: "https://ilifeapi.az.tku.edu.tw/api/ilifeStuClassApi?q=\(q)") else {
            self.errorMessage = "Invalid URL"
            self.isLoading = false
            return
        }

        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"

        isLoading = true

        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> [String: Any] in
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                guard let jsonDict = json as? [String: Any] else {
                    throw URLError(.badServerResponse)
                }
                return jsonDict
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    print("Request completed successfully")
                    self?.isLoading = false
                case .failure(let error):
                    print("Request failed with error: \(error.localizedDescription)")
                    self?.isLoading = false
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] apiData in
                self?.weekCourses = self?.parseCourseData(apiData: apiData) ?? []
                self?.isLoading = false
                print("b \(String(describing: self?.isLoading))")
            }
            .store(in: &cancellables)

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
                        var startTime: String = ""
                        var endTime: String = ""

                        if let firstSession = sesses.first, let lastSession = sesses.last,
                           let firstSessionInt = Int(firstSession), let lastSessionInt = Int(lastSession) {
                            startTime = sessionToStartTime(session: firstSessionInt)
                            endTime = sessionToEndTime(session: lastSessionInt)
                        }

                        weekCourses[weekIndex - 1].append(Course(name: name, room: room, teacher: teacher, time: time, startTime: startTime, endTime: endTime, stdNo: seat_no))
                    }
                }
            }
        }
        return weekCourses
    }

    private func sessionToStartTime(session: Int) -> String {
        switch session {
        case 1: return "08:10"
        case 2: return "09:10"
        case 3: return "10:10"
        case 4: return "11:10"
        case 5: return "12:10"
        case 6: return "13:10"
        case 7: return "14:10"
        case 8: return "15:10"
        case 9: return "16:10"
        case 10: return "17:10"
        case 11: return "18:10"
        case 12: return "19:10"
        case 13: return "20:10"
        case 14: return "21:10"
        default: return "Unknown Time"
        }
    }

    private func sessionToEndTime(session: Int) -> String {
        switch session {
        case 1: return "09:00"
        case 2: return "10:00"
        case 3: return "11:00"
        case 4: return "12:00"
        case 5: return "13:00"
        case 6: return "14:00"
        case 7: return "15:00"
        case 8: return "16:00"
        case 9: return "17:00"
        case 10: return "18:00"
        case 11: return "19:00"
        case 12: return "20:00"
        case 13: return "21:00"
        case 14: return "22:00"
        default: return "Unknown Time"
        }
    }

}
