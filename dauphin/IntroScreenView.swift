//
//  IntroScreenView.swift
//  dauphin
//
//  Created by \u8b19 on 12/18/24.
//

import SwiftUI

struct InrtoScreen: View {
    // Visibility Status
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    var body: some View {
        VStack(spacing: 15) {
            Text("Welcome to Dauphin")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .padding(.top, 65)
                .padding(.bottom, 35)
            
            //Points View
            VStack(alignment: .leading, spacing: 25,content: {
                PointView(symbol: "laptopcomputer.trianglebadge.exclamationmark", title: "Open Source", subtitle: "我們會開放我們的原始碼，如果你對現在的程式感到不滿意歡迎自己到GitHub上改。")
                
                PointView(symbol: "list.bullet.rectangle", title: "Local First", subtitle: "一些重複的資料我們會用安全的方式存在本地端，讓你在連不到學校伺服器也可以知道課表。")
                
                PointView(symbol: "widget.large.badge.plus", title: "iOS Feature Support", subtitle: "我們支援了很多iOS的功能像Widget，我們心情好的話也會持續更新")
            })
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 15)
            
            Spacer(minLength: 10)
            Text("⚠️本程式並非由淡江大學資訊處開發，使用者必須自行承擔造成的所有後果")
                .font(.system(size: 8))
            
            Button(action: {
                isFirstTime = false
            }, label: {
                Text("Continue")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.white)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .padding(.vertical, 14)
                    .background(Color.blue.gradient, in: .rect(cornerRadius: 12))
                    .contentShape(.rect)
            })
        }
        .padding(15)
    }
    
    @ViewBuilder
    func PointView(symbol: String, title: String, subtitle: String) -> some View {
        HStack(spacing: 20) {
            Image(systemName: symbol)
                .font(.largeTitle)
                .foregroundStyle(Color.blue.gradient)
                .frame(width: 40)
            VStack(alignment: .leading,spacing: 6, content: {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.gray)
            })
        }
    }
}

#Preview {
    InrtoScreen()
}
