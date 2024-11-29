//
//  OtherView.swift
//  dauphin
//
//  Created by \u8b19 on 11/25/24.
//

import SwiftUI

struct OtherView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: WifiView()) {
                    Label(
                        title: { Text("行事曆") },
                        icon: { Image(systemName: "calendar")}
                    )
                }
                
                NavigationLink(destination: WifiView()) {
                    Label(
                        title: { Text("圖書館") },
                        icon: { Image(systemName: "books.vertical.fill") }
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
                        title: { Text("校園資訊") },
                        icon: { Image(systemName: "map.fill")}
                    )
                }
            }
            .navigationTitle("Browse")
        }
    }
}

#Preview {
    OtherView()
}
