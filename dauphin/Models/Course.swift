//
//  Course.swift
//  campuspass_ios
//
//  Created by \u8b19 on 11/17/24.
//

import Foundation

struct Course: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
    var room: String
    var teacher: String
    var time: String
    var startTime: Date
    var endTime: Date
    var stdNo: String
    var weekday: Int
}

func getNextUpCourse(from weeklyschedule: [Course]) -> Course? {
    return weeklyschedule[0]
}


func getCourseStartHourMinute(_ course: Course) -> (hour: Int, minute: Int) {
    let calendar = Calendar.current
    let startHour = calendar.component(.hour, from: course.startTime)
    let startMinute = calendar.component(.minute, from: course.startTime)
    return (startHour, startMinute)
}

func getCourseEndHourMinute(_ course: Course) -> (hour: Int, minute: Int) {
    let calendar = Calendar.current
    let endHour = calendar.component(.hour, from: course.endTime)
    let endMinute = calendar.component(.minute, from: course.endTime)
    return (endHour, endMinute)
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
