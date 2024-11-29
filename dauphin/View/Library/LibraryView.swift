//
//  LibraryView.swift
//  dauphin
//
//  Created by \u8b19 on 11/25/24.
//

import SwiftUI

struct LibraryView: View {
    @ObservedObject var authViewModel: AuthViewModel
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    LibraryView(authViewModel: AuthViewModel())
}
