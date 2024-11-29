//
//  SettingView.swift
//  campuspass_ios
//
//  Created by \u8b19 on 11/14/24.
//

import SwiftUI

struct SettingView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: LibMainView(viewModel: viewModel)) {
                    Label(
                        title: { Text("登出/登入") },
                        icon: { Image(systemName: "person.crop.circle")}
                    )
                }
                
                NavigationLink(destination: PassWordView()) {
                    Label(
                        title: { Text("密碼") },
                        icon: { Image(systemName: "person.badge.key") }
                    )
                }
                
                NavigationLink(destination: WifiView()) {
                    Label(
                        title: { Text("無線網路") },
                        icon: { Image(systemName: "wifi")}
                    )
                }
                
                NavigationLink(destination: WifiView()) {
                    Label(
                        title: { Text("About Us") },
                        icon: { Image(systemName: "figure.wave")}
                    )
                }
            }
            .navigationTitle("Setting")
        }
    }
}

#Preview {
    SettingView(viewModel: AuthViewModel())
}
