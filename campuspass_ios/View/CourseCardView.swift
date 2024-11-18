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
    let time: String
    let stdNo: String

    var body: some View {
        HStack() {
            VStack(alignment: .leading, spacing: 8) {
                Text(courseName)
                    .font(.headline)
                Text("\(roomNumber)\n\(teacherName)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(time)
                    .font(.footnote)
                    .foregroundColor(.blue)
                    .padding(.bottom, 20)
                
                Text("\(stdNo)")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview {
    CourseCardView(courseName: "計算機組織", roomNumber: "E305", teacherName: "我", time: "11:10 - 12:10", stdNo: "178")
}
