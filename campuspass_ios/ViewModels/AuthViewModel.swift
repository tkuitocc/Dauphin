//
//  AuthViewModel.swift
//  campuspass_ios
//
//  Created by \u8b19 on 11/17/24.
//

import SwiftUI
import WebKit

class AuthViewModel: ObservableObject {
    @AppStorage(Constants.isLoggedInKey) var isLoggedIn: Bool = false {
        didSet {
            UserDefaults.standard.set(isLoggedIn, forKey: Constants.isLoggedInKey)
        }
    }
    
    @Published var ssoStuNo: String = UserDefaults.standard.string(forKey: Constants.ssoTokenKey) ?? ""
    
    func login(with token: String) {
        print("正在登入，token: \(token)")
        UserDefaults.standard.set(token, forKey: Constants.ssoTokenKey)
        DispatchQueue.main.async {
            self.isLoggedIn = true
            print("已更新登入狀態")
        }
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: Constants.ssoTokenKey)
        
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                dataStore.removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {
                    print("已清除紀錄: \(record.displayName)")
                })
            }
        }
        
        DispatchQueue.main.async {
            self.isLoggedIn = false
            self.ssoStuNo = ""
            print("已登出")
        }
    }
}
