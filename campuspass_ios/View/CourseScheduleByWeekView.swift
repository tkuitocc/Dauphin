//
//  CourseScheduleByWeekView.swift
//  campuspass_ios
//
//  Created by \u8b19 on 11/19/24.
//


import SwiftUI

struct CourseScheduleByWeekView: View {
    @ObservedObject var courseViewModel: CourseViewModel
    @Environment(\.colorScheme) var colorScheme
    
    @State private var selectedDayIndex: Int? = nil
    
    let weekdays = ["Mo", "Tu", "We", "Th", "Fr"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                HStack(alignment: .top, spacing: 20) {
                    ForEach(weekdays.indices, id: \.self) { index in
                        let day = weekdays[index]
                        
                        VStack {
                            VStack {
                                Image(systemName: "calendar")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                Text(day)
                                    .font(.headline)
                            }
                            .frame(width: 100, height: 70)
                            .cornerRadius(10)
                            
                            
                            if let courses = courseViewModel.weekCourses[safe: index] {
                                VStack(spacing: 4) {
                                    ForEach(courses, id: \.self) { course in
                                        Text(course.stdNo)
                                            .frame(width: 100, height: CGFloat(course.time.lengthOfBytes(using: .utf8)*30))
                                            .background(Color.primary.opacity(0.1))
                                            .cornerRadius(5)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.top, 20)
            }
        }
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}


// MARK: - Preview
struct CourseScheduleByWeekView_Previews: PreviewProvider {
    static var previews: some View {
        // Mock data for preview
        let mockData = [
            [Course(name: "Math", room: "101", teacher: "Dr. Smith", time: "1", startTime: "8:10", endTime: "9:00", stdNo: "69"), Course(name: "Math", room: "101", teacher: "Dr. Smith", time: "234", startTime: "9:10", endTime: "12:00", stdNo: "69")],
            [Course(name: "Science", room: "102", teacher: "Prof. Johnson", time: "4", startTime: "11:00", endTime: "12:00", stdNo: "69")],
            [Course(name: "History", room: "103", teacher: "Ms. Davis", time: "6", startTime: "13:00", endTime: "14:00", stdNo: "69")],
            [Course(name: "Art", room: "104", teacher: "Mr. Brown", time: "7", startTime: "14:00", endTime: "15:00", stdNo: "69")],
            [Course(name: "Physical Education", room: "Gym", teacher: "Coach Green", time: "8", startTime: "15:00", endTime: "16:00", stdNo: "69")]
        ]
        let courseViewModel = CourseViewModel(mockData: mockData)
        
        CourseScheduleByWeekView(courseViewModel: courseViewModel)
            .previewDevice("iPhone 16")
    }
}
