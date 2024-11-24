//
//  CourseCardView.swift
//  campuspass_ios
//
//  Created by \u8b19 on 11/17/24.
//
import  SwiftUI

struct CourseCardView: View {
    let courseName: String
    let roomNumber: String
    let teacherName: String
    let StartTime: Date
    let EndTime: Date
    let stdNo: String

    @Environment(\.colorScheme) var colorScheme

        var body: some View {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(courseName)
                        .font(.headline)
                        .foregroundColor(colorScheme == .dark ? .orange : .blue)
                    Text("\(roomNumber)\n\(teacherName)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("\(formatTime(StartTime)) ~ \(formatTime(EndTime))")
                        .font(.footnote)
                        .foregroundColor(colorScheme == .dark ? .orange : .green)
                        .padding(.bottom, 20)
                    
                    Text("\(stdNo)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(colorScheme == .dark ? Color.black.opacity(0.5) : Color.white)
                .cornerRadius(10)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(colorScheme == .dark ? Color.gray.opacity(0.5) : Color.gray.opacity(0.3)),
                    alignment: .bottom
                )
        }
}

func formatTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: date)
}

#Preview {
    CourseCardView(courseName: "計算機組織", roomNumber: "E305", teacherName: "我", StartTime: stringToTime("8:10")!, EndTime: stringToTime("9:00")! , stdNo: "178")
}
