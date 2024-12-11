//
//  NextUpLockScreenView.swift
//  dauphin
//
//  Created by \u8b19 on 11/29/24.
//
import SwiftUI
import WidgetKit

struct CoursesNextUpViewLockScreenView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var entry: Provider.Entry

    var body: some View {
        if(entry.ssoStuNo.isEmpty) {
            Text(entry.ssoStuNo.isEmpty ? "尚未登入" : entry.ssoStuNo)
                .font(.headline)
                .padding()
                .containerBackground(for: .widget) {
                    Color(UIColor.systemBackground)
                }
        }else{
            
        }
        if(entry.courses.isEmpty){
            Text("下週見")
                .font(.caption2)
                .padding()
                .containerBackground(for: .widget) {
                    Color(UIColor.systemBackground)
                }
        }else{
            HStack(alignment: .top) {
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 4)
                    .clipShape(RoundedRectangle(cornerRadius: 2, style: .continuous))
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(entry.courses[0].name)")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(colorScheme == .dark ? .white : .gray)
                    
                    Text("\(formatTime(entry.courses[0].startTime)) - \(formatTime(entry.courses[0].endTime))")
                        .font(.system(size: 12))
                        .foregroundColor(colorScheme == .dark ? .white : .gray)
                    
                    HStack {
                        Image(systemName: "location.circle")
                        Text(": \(entry.courses[0].room)")
                            .font(.system(size: 12))
                            .foregroundColor(colorScheme == .dark ? .white : .gray)
                        
                        Spacer(minLength: 20)
                        
                        Image(systemName: "graduationcap")
                        Text(": \(entry.courses[0].stdNo)")
                            .font(.system(size: 12))
                            .foregroundColor(colorScheme == .dark ? .white : .gray)
                    }
                }
            }
            .padding(.vertical, 16)
            .containerBackground(for: .widget) {
                Color(UIColor.systemBackground)
            }
        }
    }
    
    func currentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd"
        return formatter.string(from: Date())
    }
        
    func currentDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: Date())
    }
}
