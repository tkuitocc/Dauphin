//
//  CourseScheduleByDayView.swift
//  campuspass_ios
//
//  Created by \u8b19 on 11/17/24.
//

import SwiftUI

struct CourseScheduleByDayView: View {
    @ObservedObject var courseViewModel: CourseViewModel
    @State private var selectedDayIndex: Int = {
            let weekday = Calendar.current.component(.weekday, from: Date())
            switch weekday {
            case 2: return 0
            case 3: return 1
            case 4: return 2
            case 5: return 3 
            case 6: return 4
            case 7: return 5
            default: return 0
            }
        }()
    @Environment(\.colorScheme) var colorScheme
    
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
                    .background(selectedDayIndex == index ? colorScheme == .dark ? .orange : .blue : Color.clear)
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
                        CourseCardView(courseName: course.name, roomNumber: course.room, teacherName: course.teacher, StartTime: course.startTime, EndTime: course.endTime, stdNo: course.stdNo)
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
            [Course(name: "Math", room: "101", teacher: "Dr. Smith", time: "1", startTime: "8:10", endTime: "9:00", stdNo: "69")],
            [Course(name: "Science", room: "102", teacher: "Prof. Johnson", time: "4", startTime: "11:00", endTime: "12:00", stdNo: "69")],
            [Course(name: "History", room: "103", teacher: "Ms. Davis", time: "6", startTime: "13:00", endTime: "14:00", stdNo: "69")],
            [Course(name: "Art", room: "104", teacher: "Mr. Brown", time: "7", startTime: "14:00", endTime: "15:00", stdNo: "69")],
            [Course(name: "Physical Education", room: "Gym", teacher: "Coach Green", time: "8", startTime: "15:00", endTime: "16:00", stdNo: "69")]
        ]
        let courseViewModel = CourseViewModel(mockData: mockData)
        
        CourseScheduleByDayView(courseViewModel: courseViewModel)
            .previewDevice("iPhone 16")
    }
}
