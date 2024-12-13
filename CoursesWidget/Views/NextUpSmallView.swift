//
//  NextUpViewSmall.swift
//  CoursesWidgetExtension
//
//  Created by \u8b19 on 11/29/24.
//

import SwiftUI
import WidgetKit

struct CoursesNextUpSmallView: View {
    @Environment(\.colorScheme) var colorScheme
    var entry: Provider.Entry
    let currentWeekday = Calendar.current.component(.weekday, from: Date())
    var todayNotDoneCount: Int {
        entry.courses.filter { $0.weekday == currentWeekday }.count
    }
    var body: some View {
        if(entry.ssoStuNo.isEmpty) {
            Text(entry.ssoStuNo.isEmpty ? "尚未登入" : entry.ssoStuNo)
                .font(.headline)
                .padding()
                .containerBackground(for: .widget) {
                    Color(UIColor.systemBackground)
                }
        }else{
            if(entry.courses.isEmpty){
                Text("下週見")
                    .font(.caption2)
                    .padding()
                    .containerBackground(for: .widget) {
                        Color(UIColor.systemBackground)
                    }
            }else{
                VStack(alignment: .leading, spacing: 5) {
                    // First Event
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("\(entry.courses[1].name)")
                                .font(.headline)
                        }
                        Text("\(formatTime(entry.courses[0].startTime)) - \(formatTime(entry.courses[0].endTime))")
                            .font(.system(size: 12))
                        
                        HStack {
                            Image(systemName: "location.circle")
                                .resizable()
                                .frame(width: 15, height: 15)
                            Text(": \(entry.courses[0].room)")
                                .font(.system(size: 12))
                        }
                        HStack {
                            Image(systemName: "graduationcap")
                                .resizable()
                                .frame(width: 15, height: 15)
                            Text(": \(entry.courses[0].stdNo)")
                                .font(.system(size: 12))
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
                    if(entry.courses.count > 1){
                        VStack(alignment: .leading, spacing: 0) {
                            VStack {
                                Text("\(entry.courses[1].name)")
                                    .font(.subheadline)
                                Spacer()
                            }
                            Text("\(formatTime(entry.courses[1].startTime))")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                        .padding(.leading, 4)
                        .overlay(
                            Capsule()
                                .fill(Color.blue.opacity(0.6))
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
