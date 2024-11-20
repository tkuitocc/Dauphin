//
//  AuthViewModel.swift
//  campuspass_ios
//
//  Created by \u8b19 on 11/17/24.
//

import SwiftUI
import WebKit

class AuthViewModel: ObservableObject {
    @AppStorage(Constants.isLoggedInKey) var isLoggedIn: Bool = false
    @AppStorage(Constants.ssoTokenKey) var ssoStuNo: String = ""

    func login(with token: String) {
        print("正在登入，token: \(token)")
        DispatchQueue.main.async {
            self.ssoStuNo = token
            self.isLoggedIn = true
            print("已更新登入狀態")
        }
    }

    func logout() {
        UserDefaults.standard.removeObject(forKey: Constants.ssoTokenKey)
        
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                dataStore.removeData(ofTypes: record.dataTypes, for: [record]) {
                    print("已清除紀錄: \(record.displayName)")
                }
            }
        }
        
        DispatchQueue.main.async {
            self.isLoggedIn = false
            self.ssoStuNo = ""
            print("已登出")
        }
    }
}
