//
//  LibMainView.swift
//  campuspass_ios
//
//  Created by \u8b19 on 11/17/24.
//

import SwiftUI

struct LibMainView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var ssoStuNo: String {
        UserDefaults.standard.string(forKey: Constants.ssoTokenKey) ?? ""
    }
    
    var body: some View {
        VStack {
            if !ssoStuNo.isEmpty {
                Text("\(ssoStuNo)")
                    .padding()
            }
            
            Button(action: {
                viewModel.logout()
            }) {
                Text("登出")
                    .foregroundColor(.red)
                    .padding()
            }
        }
    }
}

