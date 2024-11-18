//
//  CourseScheduleByDayView.swift
//  campuspass_ios
//
//  Created by \u8b19 on 11/17/24.
//

import SwiftUI

struct CourseScheduleByDayView: View {
    @ObservedObject var courseViewModel: CourseViewModel
    @State private var selectedDayIndex: Int = 2
    
    var body: some View {
        VStack(spacing: 16) {
            // Weekday Selector
            HStack(spacing: 20) {
                ForEach(0..<5, id: \.self) { index in
                    let day = ["Mo", "Tu", "We", "Th", "Fr"][index]
                
                    VStack {
                        Image(systemName: "calendar")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text(day)
                            .font(.headline)
                            .foregroundColor(selectedDayIndex == index ? .white : .primary)
                    }
                    .frame(width: 50, height: 70)
                    .background(selectedDayIndex == index ? Color.blue : Color.clear)
                    .cornerRadius(10)
                    .onTapGesture {
                        selectedDayIndex = index
                    }
                }
            }
            .padding(.top, 20)
            
            // Course Cards
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(courseViewModel.weekCourses[selectedDayIndex], id: \.self) { course in
                        CourseCardView(courseName: course.name, roomNumber: course.room, teacherName: course.teacher, time: course.time, stdNo: course.stdNo)
                    }
                }
            }
        }
    }
}

// MARK: - Preview
struct CourseScheduleByDayView_Previews: PreviewProvider {
    static var previews: some View {
        // Mock data for preview
        let mockData = [
            [Course(name: "Math", room: "101", teacher: "Dr. Smith", time: "10:00 AM - 11:00 AM", stdNo: "69") ],
            [Course(name: "Science", room: "102", teacher: "Prof. Johnson", time: "11:00 AM - 12:00 PM", stdNo: "69")],
            [Course(name: "History", room: "103", teacher: "Ms. Davis", time: "1:00 PM - 2:00 PM", stdNo: "69")],
            [Course(name: "Art", room: "104", teacher: "Mr. Brown", time: "2:00 PM - 3:00 PM", stdNo: "69")],
            [Course(name: "Physical Education", room: "Gym", teacher: "Coach Green", time: "3:00 PM - 4:00 PM", stdNo: "69")]
        ]
        let courseViewModel = CourseViewModel(mockData: mockData)
        
        CourseScheduleByDayView(courseViewModel: courseViewModel)
            .previewDevice("iPhone 16")
    }
}
