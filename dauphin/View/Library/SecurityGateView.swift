//
//  SecurityGateView.swift
//  dauphin
//
//  Created by \u8b19 on 11/25/24.
//

import SwiftUI

struct SecurityGateView: View {
    @State private var PASSWORD: String = ""
    @ObservedObject var authViewModel: AuthViewModel
    let colors: [String]
    let widths: [Int]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "n.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                Text("發票存摺")
                    .font(.callout)
                    .foregroundColor(.white)
            }
            .padding(10)
            .frame(maxWidth: .infinity)
            .background(Color.blue)
                    
            VStack(alignment: .center, spacing: 0) {
                GeometryReader { geometry in
                    let totalWidth = geometry.size.width / 2
                    let scaleFactor = geometry.size.width / totalWidth
                    let barHeight = geometry.size.height
                    
                    HStack(spacing: 0) {
                        ForEach(0..<colors.count, id: \.self) { index in
                            Rectangle()
                                .fill(colors[index] == "k" ? Color.black : Color.white)
                                .frame(width: CGFloat(widths[index]) * scaleFactor, height: barHeight)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.clear)
                }
                .frame(height: 120)
                .background(Color.white)
                .frame(maxWidth: .infinity)
            }
            .padding(7)
                    
            Text("載具條碼：/YK32E6B")
                .font(.subheadline)
                .foregroundColor(.black)
            }
            .frame(width: 380)
            .background(Color.white)
            .cornerRadius(20)
    }
        
}

#Preview {
    SecurityGateView(authViewModel: AuthViewModel(),
                     colors: ["e", "k", "e", "e", "k", "e", "k", "e", "k", "e", "k", "e", "k", "e", "k", "e", "k", "e", "k", "e", "e", "k", "e", "k", "e", "k", "e", "k", "e", "k", "e", "e", "k", "e", "k", "e", "e", "k", "e", "k", "e", "k", "e", "k", "e", "k", "e", "k", "e", "e", "k", "e", "k", "e", "k", "e", "k", "e", "k", "e", "e", "k", "e", "k", "e", "k", "e", "k", "e", "k", "e", "e", "k", "e", "k", "e", "k", "e", "k", "e", "k", "e", "e", "k", "e", "k", "e", "k", "e", "k", "e", "k", "e", "e", "k", "e", "k", "e", "k", "e", "k", "e", "k", "e", "e", "k", "e", "k", "e", "k", "e", "k", "e", "e", "k", "e", "k", "e", "k", "e", "k", "e", "k", "e", "e", "k", "e", "k", "e", "k", "e", "k", "e"],
                     widths: [1, 1, 1, 1, 1, 1, 2, 1, 2, 1, 1, 1, 1, 1, 1, 1, 2, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 2, 1, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 2, 1, 2, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 2, 1, 2, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 2, 1, 1, 1]
    )
}
