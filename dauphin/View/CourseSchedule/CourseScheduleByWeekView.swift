//
//  CourseScheduleByWeekView.swift
//  campuspass_ios
//
//  Created by \u8b19 on 11/19/24.
//


import SwiftUI

struct CourseScheduleByWeekView: View {
    
    @ObservedObject var courseViewModel: CourseViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
               
                HStack(spacing: 3) {
                    ForEach(0..<6, id: \.self) { index in
                        let day = ["Mo", "Tu", "We", "Th", "Fr", "Sa"][index]
                        VStack {
                            Text(day)
                                .font(.headline)
                        }
                        .frame(width: geometry.size.width / 6 - 10)
                    }
                }
                .padding(.horizontal)
                .frame(height: 20)
                HStack(spacing: 1) {
                    ForEach(0..<6, id: \.self) { index in
                        Text("\(courseViewModel.weekCourses[0])")
                        .frame(width: geometry.size.width / 6 - 10)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct TimeSlotGrid: View {
    let numberOfSlots: Int
    let totalHeight: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<numberOfSlots, id: \.self) { index in
                RoundedRectangle(cornerRadius: 2)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
                    .frame(height: totalHeight / CGFloat(numberOfSlots))

            }
        }
    }
}

struct CourseView: View {
    let course: Course
    let height: CGFloat
    let yOffset: CGFloat
    
    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(Color.blue.opacity(1))
            .frame(height: height*0.98)
            .overlay(
                VStack(alignment: .leading, spacing: 2) {
                    Text(course.name)
                        .font(.caption)
                        .bold()
                        .foregroundColor(.white)
                    Text(course.room)
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.7))
                    Text(course.stdNo)
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding(4),
                alignment: .topLeading
            )
            .offset(y: yOffset)
    }
}

// 主視圖
struct SingleTimeline: View {
    @Binding var courses: [Course]
    
    let baseDate = Calendar.current.startOfDay(for: Date())
    let start = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Calendar.current.startOfDay(for: Date()))!
    let end = Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: Calendar.current.startOfDay(for: Date()))!
    
    var body: some View {
        GeometryReader { geometry in
            let totalHeight = geometry.size.height
            let numberOfSlots = 14
            
            ZStack(alignment: .top) {
                TimeSlotGrid(numberOfSlots: numberOfSlots, totalHeight: totalHeight)
            
                ForEach(courses) { course in
                    let adjustedStartTime = adjustedTime(for: course.startTime)
                    let adjustedEndTime = adjustedTime(for: course.endTime)
                    
                    CourseView(
                        course: course,
                        height: heightForEvent(adjustedStartTime, adjustedEndTime, in: totalHeight),
                        yOffset: yPosition(for: adjustedStartTime, in: totalHeight)
                    )
                }
            }
        }
    }

    // 調整時間到整點
    private func adjustedTime(for time: Date) -> Date {
        let calendar = Calendar.current
        return calendar.date(bySettingHour: calendar.component(.hour, from: time), minute: 0, second: 0, of: baseDate)!
    }

    // 計算課程的高度
    private func heightForEvent(_ startTime: Date, _ endTime: Date, in totalHeight: CGFloat) -> CGFloat {
        let totalDuration = end.timeIntervalSince(start)
        let eventDuration = endTime.timeIntervalSince(startTime)
        return CGFloat(eventDuration / totalDuration) * totalHeight
    }

    // 計算課程的垂直位置
    private func yPosition(for time: Date, in totalHeight: CGFloat) -> CGFloat {
        let totalDuration = end.timeIntervalSince(start)
        let eventOffset = time.timeIntervalSince(start)
        let relativePosition = eventOffset / totalDuration
        return CGFloat(relativePosition) * totalHeight
    }
}



#Preview{
    let courseViewModel = CourseViewModel(mockData: mockData)
    CourseScheduleByWeekView(courseViewModel: courseViewModel)
}
