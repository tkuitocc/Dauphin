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
        if(entry.course == nil){
            Text("下週見")
                .font(.caption2)
                .padding()
                .containerBackground(for: .widget) {
                    Color(UIColor.systemBackground)
                }
        }else{
            VStack(alignment: .trailing, spacing: 5) {
                VStack {
                    Text(currentDay())
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.blue)
                    Text(currentDate())
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(colorScheme == .dark ? .white : .gray)
                }
                
                Spacer()
                
                HStack(alignment: .top) {
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 4)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("\(entry.course?.name ?? "")")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(colorScheme == .dark ? .white : .gray)
                        Text("\(entry.course?.room ?? "")")
                            .font(.system(size: 12))
                            .foregroundColor(colorScheme == .dark ? .white : .gray)
                        Text("\(formatTime(entry.course?.startTime)) ~ \(formatTime(entry.course?.endTime))")
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
