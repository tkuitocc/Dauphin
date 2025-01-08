//
//  LibraryView.swift
//  dauphin
//
//  Created by \u8b19 on 11/25/24.
//

import SwiftUI
import Code39

struct LibraryView: View {
    @ObservedObject var authViewModel: AuthViewModel
    var body: some View {
        if authViewModel.isLoggedIn {
            ScrollView{
                VStack {
                    Text("圖書館個人條碼")
                    Code39View("\(authViewModel.ssoStuNo)")
                        .frame(width: 296, height: 96)
                    Text("學號：\(authViewModel.ssoStuNo)")
                }
            }
        } else {
            LibSSOLoginView(viewModel: authViewModel)
        }
    }
}

#Preview {
    LibraryView(authViewModel: AuthViewModel())
}
