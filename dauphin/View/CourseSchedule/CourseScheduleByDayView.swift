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
    @Environment(\.colorScheme) var colorSchem
    
    var body: some View {
        VStack {
            if courseViewModel.weekCourses.isEmpty {
                Text("Loading courses...")
            } else if !courseViewModel.weekCourses.isEmpty {
                Text("\(courseViewModel.weekCourses[0])")
            } else {
                Text("No courses available.")
            }
        }
    }
}

#Preview{
    let courseViewModel = CourseViewModel(mockData: mockData)
    CourseScheduleByDayView(courseViewModel: courseViewModel)
}
