//
//  ContentView.swift
//  campuspass_ios
//
//  Created by \u8b19 on 11/14/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                HomeView()
            }
            Tab("Course", systemImage: "calendar.day.timeline.left"){
                CourseScheduleView()
            }
            Tab("setting", systemImage: "gear") {
                SettingView()
            }
        }
    }
}

#Preview {
    ContentView()
}
