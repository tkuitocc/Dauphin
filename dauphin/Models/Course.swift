//
//  Course.swift
//  campuspass_ios
//
//  Created by \u8b19 on 11/17/24.
//

import Foundation

// MARK: - Course Model
struct Course: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
    var room: String
    var teacher: String
    var time: String
    var startTime: Date
    var endTime: Date
    var stdNo: String
}

func getNextUpCourse(from schedule: [[Course]]) -> Course? {
    let currentTime = Date()
    let calendar = Calendar.current
        
    let timeAfter20Minutes = calendar.date(byAdding: .minute, value: 20, to: currentTime)!
        
    let weekday = calendar.component(.weekday, from: currentTime)
    let todayIndex = weekday - 2

    for dayOffset in 0..<6 {
        let dayIndex = (todayIndex + dayOffset) % 6
        let isToday = (dayOffset == 0)
            
        let courses = schedule[dayIndex].filter { isToday ? $0.startTime > timeAfter20Minutes : true }
            
        if let nextCourse = courses.min(by: { $0.startTime < $1.startTime }) {
            return nextCourse
        }
    }
    return nil
}

func stringToTime(_ timeString: String) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    formatter.timeZone = TimeZone.current
    
    return formatter.date(from: timeString)
}

func formatTime(_ date: Date?) -> String {
    guard let date = date else {
        return "ERROR"
    }
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: date)
}

let mockData: [[Course]] = [
    [
        Course(name: "Math", room: "101", teacher: "Dr. Smith", time: "1",
               startTime: stringToTime("08:10") ?? Date(),
               endTime: stringToTime("09:00") ?? Date(),
               stdNo: "69"),
        Course(name: "Physical Education", room: "Gym", teacher: "Coach Green", time: "8",
               startTime: stringToTime("9:10") ?? Date(),
               endTime: stringToTime("10:00") ?? Date(),
               stdNo: "69"),
        Course(name: "Physical Education", room: "Gym", teacher: "Coach Green", time: "8",
               startTime: stringToTime("10:10") ?? Date(),
               endTime: stringToTime("11:00") ?? Date(),
               stdNo: "69"),
        Course(name: "Math", room: "101", teacher: "Dr. Smith", time: "1",
               startTime: stringToTime("11:10") ?? Date(),
               endTime: stringToTime("12:00") ?? Date(),
               stdNo: "69"),
        Course(name: "Math", room: "101", teacher: "Dr. Smith", time: "1",
               startTime: stringToTime("13:10") ?? Date(),
               endTime: stringToTime("14:00") ?? Date(),
               stdNo: "69"),
        Course(name: "Physical Education", room: "Gym", teacher: "Coach Green", time: "8",
               startTime: stringToTime("14:10") ?? Date(),
               endTime: stringToTime("15:00") ?? Date(),
               stdNo: "69"),
        Course(name: "Math", room: "101", teacher: "Dr. Smith", time: "1",
               startTime: stringToTime("15:10") ?? Date(),
               endTime: stringToTime("16:00") ?? Date(),
               stdNo: "69"),
        Course(name: "Math", room: "101", teacher: "Dr. Smith", time: "1",
               startTime: stringToTime("16:10") ?? Date(),
               endTime: stringToTime("17:00") ?? Date(),
               stdNo: "69"),
        Course(name: "Physical Education", room: "Gym", teacher: "Coach Green", time: "8",
               startTime: stringToTime("17:10") ?? Date(),
               endTime: stringToTime("18:00") ?? Date(),
               stdNo: "69"),
        Course(name: "Math", room: "101", teacher: "Dr. Smith", time: "1",
               startTime: stringToTime("18:10") ?? Date(),
               endTime: stringToTime("19:00") ?? Date(),
               stdNo: "69"),
        Course(name: "Math", room: "101", teacher: "Dr. Smith", time: "1",
               startTime: stringToTime("19:10") ?? Date(),
               endTime: stringToTime("20:00") ?? Date(),
               stdNo: "69"),
        Course(name: "Physical Education", room: "Gym", teacher: "Coach Green", time: "8",
               startTime: stringToTime("20:10") ?? Date(),
               endTime: stringToTime("21:00") ?? Date(),
               stdNo: "69"),
        Course(name: "Math", room: "101", teacher: "Dr. Smith", time: "1",
               startTime: stringToTime("21:10") ?? Date(),
               endTime: stringToTime("22:00") ?? Date(),
               stdNo: "69"),
        
    ],
    [
        Course(name: "Science", room: "102", teacher: "Prof. Johnson", time: "4",
               startTime: stringToTime("11:10") ?? Date(),
               endTime: stringToTime("12:00") ?? Date(),
               stdNo: "69"),
        Course(name: "Physical Education", room: "Gym", teacher: "Coach Green", time: "8",
               startTime: stringToTime("15:10") ?? Date(),
               endTime: stringToTime("16:00") ?? Date(),
               stdNo: "69")
    ],
    [
        Course(name: "History", room: "103", teacher: "Ms. Davis", time: "6",
               startTime: stringToTime("13:10") ?? Date(),
               endTime: stringToTime("14:00") ?? Date(),
               stdNo: "69")
    ],
    [
        Course(name: "Art", room: "104", teacher: "Mr. Brown", time: "7",
               startTime: stringToTime("14:10") ?? Date(),
               endTime: stringToTime("15:00") ?? Date(),
               stdNo: "69"),
        Course(name: "Physical Education", room: "Gym", teacher: "Coach Green", time: "8",
               startTime: stringToTime("15:10") ?? Date(),
               endTime: stringToTime("16:00") ?? Date(),
               stdNo: "69")
    ],
    [
        Course(name: "Physical Education", room: "Gym", teacher: "Coach Green", time: "8",
               startTime: stringToTime("15:10") ?? Date(),
               endTime: stringToTime("16:00") ?? Date(),
               stdNo: "69")
    ],
    
    [
        Course(name: "Physical Education", room: "Gym", teacher: "Coach Green", time: "8",
               startTime: stringToTime("15:10") ?? Date(),
               endTime: stringToTime("16:00") ?? Date(),
               stdNo: "69")
    ],
    
]
