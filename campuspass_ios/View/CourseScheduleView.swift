//
//  CourseScheduleView.swift
//  campuspass_ios
//
//  Created by \u8b19 on 11/14/24.
//

import SwiftUI
import Foundation

struct CourseScheduleView: View {
    @StateObject private var AuthviewModel = AuthViewModel()
    let viewModel = CourseViewModel()
    var ssoStuNo: String {
        UserDefaults.standard.string(forKey: Constants.ssoTokenKey) ?? ""
    }
    
    
    
    var body: some View {
        Group {
            if AuthviewModel.isLoggedIn {
                CourseScheduleByDayView(courseViewModel: viewModel)
                    .padding(20)
                    .onAppear {
                        if !ssoStuNo.isEmpty {
                            viewModel.fetchCourses(with: ssoStuNo)
                            print(viewModel.weekCourses)
                        }
                    }
            } else {
                LibSSOLoginView(viewModel: AuthviewModel)
            }
        }
    }
}

#Preview {
    CourseScheduleView()
}
