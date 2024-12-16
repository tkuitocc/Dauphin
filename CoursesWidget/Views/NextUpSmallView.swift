//
//  NextUpViewSmall.swift
//  CoursesWidgetExtension
//
//  Created by \u8b19 on 11/29/24.
//

import SwiftUI
import WidgetKit

import SwiftUI
import WidgetKit

struct CoursesNextUpSmallView: View {
    @Environment(\.colorScheme) var colorScheme
    var entry: Provider.Entry
    let currentWeekday = Calendar.current.component(.weekday, from: Date())
    
    var todayNotDoneCount: Int {
        entry.courses.filter { $0.weekday == currentWeekday }.count
    }
    
    // Helper function to convert weekday index to name
    func weekdayName(for weekday: Int) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US") // Change locale if needed
        formatter.dateFormat = "EEEE"
        let date = Calendar.current.date(bySetting: .weekday, value: weekday+1, of: Date())!
        return formatter.string(from: date)
    }
    
    var body: some View {
        if entry.ssoStuNo.isEmpty {
            Text("尚未登入")
                .font(.headline)
                .padding()
                .containerBackground(for: .widget) {
                    Color(UIColor.systemBackground)
                }
        } else {
            if entry.courses.isEmpty {
                Text("下週見")
                    .font(.caption2)
                    .padding()
                    .containerBackground(for: .widget) {
                        Color(UIColor.systemBackground)
                    }
            } else {
                VStack(alignment: .leading, spacing: 5) {
                    // First Event
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("\(entry.courses[0].name)")
                                .font(.headline)
                            Spacer()
                        }
                        Text("\(formatTime(entry.courses[0].startTime)) - \(formatTime(entry.courses[0].endTime))")
                            .font(.footnote)
                        
                        HStack {
                            HStack(spacing: 0) {
                                Image(systemName: "location.circle.fill")
                                    .font(.system(size: 8))
                                Text(": \(entry.courses[0].room)")
                                    .font(.system(size: 10))
                                    .foregroundColor(.primary)
                            }
                            .padding(.vertical, 2)
                            .padding(.horizontal, 5)
                            .background(Color.blue.opacity(0.8))
                            .cornerRadius(4)
                            
                            HStack(spacing: 0) {
                                Image(systemName: "graduationcap")
                                    .font(.system(size: 8))
                                Text(": \(entry.courses[0].stdNo)")
                                    .font(.system(size: 10))
                                    .foregroundColor(.primary)
                            }
                            .padding(.vertical, 2)
                            .padding(.horizontal, 5)
                            .background(Color.blue)
                            .cornerRadius(4)
                        }
                    }
                    .padding(.leading, 4)
                    .overlay(
                        Capsule()
                            .fill(Color.blue)
                            .frame(width: 4)
                            .padding(.leading, -8),
                        alignment: .leading
                    )
                    
                    // Second Event
                    if entry.courses.count > 1 {
                        let isSameDay = entry.courses[0].weekday == entry.courses[1].weekday
                        let secondCourseWeekday = weekdayName(for: entry.courses[1].weekday)
                        
                        if(isSameDay){
                            Text("")
                        }else{
                            Text(secondCourseWeekday)
                                .font(.footnote)
                                .padding(.leading, -8)
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            VStack {
                                Text("\(entry.courses[1].name)")
                                    .font(.subheadline)
                                Spacer()
                            }
                            Text("\(formatTime(entry.courses[1].startTime)) - \(formatTime(entry.courses[1].endTime))")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                        .padding(.leading, 4)
                        .overlay(
                            Capsule()
                                .fill(isSameDay ? Color.blue : Color.orange)
                                .frame(width: 4)
                                .padding(.leading, -8),
                            alignment: .leading
                        )
                    }
                }
                .containerBackground(for: .widget) {
                    Color(UIColor.systemBackground)
                }
            }
        }
    }
}


#Preview(as: .systemSmall) {
    CoursesNextUpWidget()
} timeline: {
    SimpleEntry(date: Date(), ssoStuNo: "111111111", courses: mockData, today: mockData.count)
}
