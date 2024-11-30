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
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(.bottom, 20)
                    
                    Text("\(roomNumber)")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("\(formatTime(StartTime)) ~ \(formatTime(EndTime))")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.bottom, 10)
                    
                    Text("\(teacherName)")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    Text("成績座號：\(stdNo)")
                        .font(.footnote)
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Color.cyan)
                        .cornerRadius(5)
                }
            }
            .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.blue)
                .cornerRadius(15)
        }
}

#Preview {
    CourseCardView(courseName: "計算機組織", roomNumber: "E305", teacherName: "我", StartTime: stringToTime("8:10")!, EndTime: stringToTime("9:00")! , stdNo: "178")
}


