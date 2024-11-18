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
        if let encrypted = helper?.encrypt(data: "20220901200540356,"+stdNo){
            if let q = encrypted.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
                guard let url = URL(string: "https://ilifeapi.az.tku.edu.tw/api/ilifeStuClassApi?q=\(q)") else {
                    self.errorMessage = "invalid URL"
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
                            self?.isLoading = false
                        case .failure(let error):
                            self?.isLoading = false
                            self?.errorMessage = "\(error.localizedDescription)"
                        }
                    } receiveValue: { [weak self] apiData in
                        self?.weekCourses = self?.parseCourseData(apiData: apiData) ?? []
                    }
                    .store(in: &cancellables)
            }
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
                        weekCourses[weekIndex - 1].append(Course(name: name, room: room, teacher: teacher, time: time, stdNo: seat_no))
                    }
                }
            }
        }
        return weekCourses
    }
}
