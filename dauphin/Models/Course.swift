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
}

func getNextUpCourse(from schedule: [[Course]]) -> Course? {
    let currentTime = Date()
    let calendar = Calendar.current
    
    let weekday = calendar.component(.weekday, from: currentTime)
    let todayIndex = weekday - 2 // 假設週一對應索引 0，週六對應索引 5
    
    print("現在時間：\(currentTime)，今天是星期：\(weekday)，todayIndex：\(todayIndex)")
    
    // 5. 如果是星期日且已過中午
    if weekday == 1 && calendar.component(.hour, from: currentTime) >= 12 {
        print("今天是星期日且已過中午，查找下週課程")
        return getNextWeekCourse(from: schedule) // 處理下週邏輯的函數
    }

    // 4. 判斷整週是否所有課程都已結束
    let allCoursesFinished = schedule.enumerated().allSatisfy { (dayIndex, dayCourses) in
        dayCourses.allSatisfy { course in
            let (courseEndHour, courseEndMinute) = getCourseEndHourMinute(course)
            let currentHour = calendar.component(.hour, from: currentTime)
            let currentMinute = calendar.component(.minute, from: currentTime)

            print("判斷 dayIndex：\(dayIndex)，courseEndHour：\(courseEndHour)，courseEndMinute：\(courseEndMinute)，currentHour：\(currentHour)，currentMinute：\(currentMinute)")

            if dayIndex < todayIndex {
                return true // 課程所在的天早於今天，已結束
            } else if dayIndex == todayIndex {
                // 當天課程：比較結束時間和當前時間
                return courseEndHour < currentHour || (courseEndHour == currentHour && courseEndMinute <= currentMinute)
            } else {
                return false // 課程所在的天晚於今天，未結束
            }
        }
    }
    if allCoursesFinished {
        print("整週課程已結束")
        return nil
    }

    for dayOffset in 0..<6 {
        let dayIndex = (todayIndex + dayOffset) % 6
        let isToday = (dayOffset == 0)
        let courses = schedule[dayIndex]

        print("dayOffset：\(dayOffset)，dayIndex：\(dayIndex)，isToday：\(isToday)，當天課程數量：\(courses.count)")

        if courses.isEmpty {
            continue // 當天沒有課，直接跳過
        }

        if isToday {
            // 判斷今天的最後一堂課是否已結束
            if let lastCourse = courses.last {
                let (lastEndHour, lastEndMinute) = getCourseEndHourMinute(lastCourse)
                let currentHour = calendar.component(.hour, from: currentTime)
                let currentMinute = calendar.component(.minute, from: currentTime)

                print("最後一堂課結束時間：\(lastEndHour):\(lastEndMinute)，當前時間：\(currentHour):\(currentMinute)")
                
                if currentHour > lastEndHour || (currentHour == lastEndHour && currentMinute >= lastEndMinute) {
                    print("今天的課程已全部結束，跳到下一天的課程")
                    continue // 跳到未來的課程檢查
                }
            }

            // 判斷當前是否在今天的課程中
            for course in courses {
                let (startHour, startMinute) = getCourseStartHourMinute(course)
                let (endHour, endMinute) = getCourseEndHourMinute(course)
                let currentHour = calendar.component(.hour, from: currentTime)
                let currentMinute = calendar.component(.minute, from: currentTime)

                print("當前課程開始時間：\(startHour):\(startMinute)，結束時間：\(endHour):\(endMinute)，當前時間：\(currentHour):\(currentMinute)")

                // 判斷是否在當前課程範圍內
                if (currentHour > startHour || (currentHour == startHour && currentMinute >= startMinute)) &&
                    (currentHour < endHour || (currentHour == endHour && currentMinute < endMinute)) {
                    let remainingMinutes = (endHour * 60 + endMinute) - (currentHour * 60 + currentMinute)
                    print("當前課程剩餘分鐘：\(remainingMinutes) 分鐘")
                    
                    if remainingMinutes > 20 {
                        print("current")
                        return course // 當下課程尚未結束且超過 20 分鐘
                    } else {
                        print("快下課")
                        return getNextCourse(after: course, in: courses) // 回傳下一堂課
                    }
                }
            }

            // 判斷今天接下來的課程
            let nextCourses = courses.filter {
                let (startHour, startMinute) = getCourseStartHourMinute($0)
                let currentHour = calendar.component(.hour, from: currentTime)
                let currentMinute = calendar.component(.minute, from: currentTime)
                return (startHour > currentHour || (startHour == currentHour && startMinute > currentMinute))
            }
            if let nextCourse = nextCourses.min(by: { $0.startTime < $1.startTime }) {
                print("今天的下一堂課程：\(nextCourse)")
                return nextCourse
            }
        }
    }

    // 3. 如果今天課程結束，回傳明天的第一堂課
    for dayOffset in 1..<6 {
        let dayIndex = (todayIndex + dayOffset) % 6
        if let firstCourseTomorrow = schedule[dayIndex].first {
            print("Next Day：dayOffset：\(dayOffset)，dayIndex：\(dayIndex)，第一堂課：\(firstCourseTomorrow)")
            return firstCourseTomorrow
        }
    }

    return nil
}

func getNextCourse(after currentCourse: Course, in courses: [Course]) -> Course? {
    // 找到當前課程之後的下一堂課
    guard let currentIndex = courses.firstIndex(where: { $0 == currentCourse }) else { return nil }
    return courses.dropFirst(currentIndex + 1).first
}

func getNextWeekCourse(from schedule: [[Course]]) -> Course? {
    // 假設下週第一堂課是 schedule[0].first
    return schedule.first(where: { !$0.isEmpty })?.first
}

func getNextDayCourse(from schedule: [[Course]], startingFrom startIndex: Int) -> Course? {
    let currentHour = Calendar.current.component(.hour, from: Date())
    let currentMinute = Calendar.current.component(.minute, from: Date())

    for dayOffset in 0..<6 {
        let dayIndex = (startIndex + dayOffset) % 6
        let courses = schedule[dayIndex]

        if courses.isEmpty {
            continue // 跳過空課日
        }

        if let nextCourse = courses.first(where: {
            let (startHour, startMinute) = getCourseStartHourMinute($0)
            return startHour > currentHour || (startHour == currentHour && startMinute > currentMinute)
        }) {
            return nextCourse
        }
    }
    return nil // 未找到未來課程
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
