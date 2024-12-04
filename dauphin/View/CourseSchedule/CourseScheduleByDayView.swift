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
        VStack(spacing: 5) {
            // Weekday Selector
            HStack(spacing: 10) {
                ForEach(0..<6, id: \.self) { index in
                    let day = ["Mo", "Tu", "We", "Th", "Fr", "Sa"][index]
                
                    VStack {
                        Image(systemName: "calendar")
                            .resizable()
                            .foregroundColor(selectedDayIndex == index ? .blue : .primary)
                            .frame(width: 30, height: 30)
                        Text(day)
                            .font(.headline)
                            .foregroundColor(selectedDayIndex == index ? .blue : .primary)
                    }
                    .frame(width: 50, height: 70)
                    .onTapGesture {
                        selectedDayIndex = index
                    }
                }
            }
            .padding(.top, 0)
            
            // Course Cards
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(courseViewModel.weekCourses[selectedDayIndex], id: \.self) { course in
                        CourseCardView(courseName: course.name, roomNumber: course.room, teacherName: course.teacher, StartTime: course.startTime, EndTime: course.endTime, stdNo: course.stdNo)
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}

#Preview{
    let courseViewModel = CourseViewModel(mockData: mockData)
    CourseScheduleByDayView(courseViewModel: courseViewModel)
}
