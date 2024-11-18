//
//  SettingView.swift
//  campuspass_ios
//
//  Created by \u8b19 on 11/14/24.
//

import SwiftUI

struct SettingView: View {
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        Group {
            if viewModel.isLoggedIn {
                LibMainView(viewModel: viewModel)
            } else {
                LibSSOLoginView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    SettingView()
}
