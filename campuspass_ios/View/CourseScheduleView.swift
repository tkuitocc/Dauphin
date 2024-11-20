//
//  CourseScheduleView.swift
//  campuspass_ios
//
//  Created by \u8b19 on 11/14/24.
//

import SwiftUI
import Foundation

struct CourseScheduleView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @StateObject var viewModel = CourseViewModel()
    
    var body: some View {
        Group {
            if authViewModel.isLoggedIn {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    CourseScheduleByDayView(courseViewModel: viewModel)
                        .padding(20)
                        .refreshable {
                            if !authViewModel.ssoStuNo.isEmpty {
                                viewModel.fetchCourses(with: authViewModel.ssoStuNo)
                                print("Refreshing courses, isLoading:", viewModel.isLoading)
                            }
                        }
                        .onAppear {
                            if !authViewModel.ssoStuNo.isEmpty {
                                viewModel.fetchCourses(with: authViewModel.ssoStuNo)
                                print("Refreshing courses, isLoading:", viewModel.isLoading)
                            }
                        }
                }
            } else {
                LibSSOLoginView(viewModel: authViewModel)
            }
        }
    }
}

#Preview {
    CourseScheduleView(authViewModel: AuthViewModel())
}
