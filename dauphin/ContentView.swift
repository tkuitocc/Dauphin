//
//  ContentView.swift
//  campuspass_ios
//
//  Created by \u8b19 on 11/14/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AuthViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        TabView() {
            Tab("Home", systemImage: "house.fill") {
                HomeView()
            }
            
            Tab("Course", systemImage: "calendar.day.timeline.left"){
                CourseScheduleView(authViewModel: viewModel)
            }
            
            Tab("setting", systemImage: "gear") {
                SettingView(viewModel: viewModel)
            }
        }
        .accentColor(colorScheme == .dark ? .orange : .blue)
    }
}

#Preview {
    ContentView()
}
