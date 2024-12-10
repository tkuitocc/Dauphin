//
//  CourseScheduleByDayView.swift
//  campuspass_ios
//
//  Created by \u8b19 on 11/17/24.
//

import SwiftUI

struct DateItem: Identifiable {
    let id = UUID()
    let day: Int
    let weekday: String
    let isSelected: Bool
}

struct CourseScheduleByDayView: View {
    @ObservedObject var courseViewModel: CourseViewModel
    @ObservedObject var authViewModel: AuthViewModel
    @State private var selectedDateIndex: Int? = nil
    @State private var dates: [DateItem] = generateDates()
    
    static func generateDates() -> [DateItem] {
        let calendar = Calendar.current
        let today = Date()
        let weekdayFormatter = DateFormatter()
        weekdayFormatter.dateFormat = "EEE"
            
        // Calculate the start of the week (Sunday)
        let weekday = calendar.component(.weekday, from: today)
        guard let startOfWeek = calendar.date(byAdding: .day, value: -(weekday - 1), to: today) else { return [] }
            
        // Generate dates for the week
        return (0..<7).map { offset in
            let date = calendar.date(byAdding: .day, value: offset, to: startOfWeek)!
            let day = calendar.component(.day, from: date)
            let weekday = weekdayFormatter.string(from: date)
            return DateItem(day: day, weekday: weekday, isSelected: false)
        }
    }
    
    private func getFormattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM, yyyy" // Month and year format
        return formatter.string(from: Date())
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Hey, \(authViewModel.ssoStuNo).")
                    .padding(.top)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                Text(getFormattedDate())
                    .foregroundColor(.gray)
                    .padding(.horizontal)

                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(dates.indices, id: \.self) { index in
                                let date = dates[index]
                                VStack {
                                    Text("\(date.day)")
                                        .font(.headline)
                                        .foregroundColor(selectedDateIndex == index ? .white : .primary)
                                    Text(date.weekday)
                                        .font(.subheadline)
                                        .foregroundColor(selectedDateIndex == index ? .white : .gray)
                                }
                                .frame(width: 60, height: 80)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(selectedDateIndex == index ? Color.accentColor : Color(UIColor.systemGray5))
                                        .shadow(color: selectedDateIndex == index ? .gray.opacity(0.4) : .clear, radius: 4)
                                )
                                .id(index)
                                .onTapGesture {
                                    selectedDateIndex = index
                                }
                            }
                        }
                        .padding(5)
                    }
                    .gesture(DragGesture())
                    .onAppear {
                        if let todayIndex = dates.firstIndex(where: { $0.day == Calendar.current.component(.day, from: Date()) }) {
                            selectedDateIndex = todayIndex
                            proxy.scrollTo(todayIndex, anchor: .center)
                        }
                    }
                }
            }
            
            ScrollView {
                if courseViewModel.weekCourses.isEmpty {
                    Text("Loading courses...")
                        .foregroundColor(.gray)
                } else if let selectedIndex = selectedDateIndex {
                    let todaysCourses = courseViewModel.weekCourses.filter{$0.weekday == selectedIndex}
                    if(todaysCourses.count == 0){
                    }else{
                        ForEach(todaysCourses) { course in
                            CourseCardView(
                                courseName: course.name,
                                roomNumber: course.room,
                                teacherName: course.teacher,
                                StartTime: course.startTime,
                                EndTime: course.endTime,
                                stdNo: course.stdNo
                            )
                            .padding(2)
                        }
                    }
                    //Text("\(courseViewModel.weekCourses.filter{$0.weekday == selectedIndex})")
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    let courseViewModel = CourseViewModel(mockData: mockData)
    let authViewModel = AuthViewModel()
    CourseScheduleByDayView(courseViewModel: courseViewModel, authViewModel: authViewModel)
        
}
