//
//  AuthViewModel.swift
//  campuspass_ios
//
//  Created by \u8b19 on 11/17/24.
//

import SwiftUI
import WebKit
import WidgetKit

class AuthViewModel: ObservableObject {
    private let appGroupDefaults = UserDefaults(suiteName: "group.cantpr09ram.dauphin")
    
    @Published var isLoggedIn: Bool {
        didSet {
            appGroupDefaults?.set(isLoggedIn, forKey: Constants.isLoggedInKey)
        }
    }
    @Published var ssoStuNo: String {
        didSet {
            appGroupDefaults?.set(ssoStuNo, forKey: Constants.ssoTokenKey)
        }
    }
    
    init() {
        self.isLoggedIn = appGroupDefaults?.bool(forKey: Constants.isLoggedInKey) ?? false
        self.ssoStuNo = appGroupDefaults?.string(forKey: Constants.ssoTokenKey) ?? ""
    }
    
    func login(with token: String) {
        print("正在登入，token: \(token)")
        DispatchQueue.main.async {
            self.ssoStuNo = token
            self.isLoggedIn = true
            print("已更新登入狀態")
            //update user defaults for widget
            WidgetCenter.shared.reloadAllTimelines()
            // Directly check the App Group storage
            if let savedValue = self.appGroupDefaults?.string(forKey: Constants.ssoTokenKey) {
                print("儲存的 ssoStuNo: \(savedValue) \(Constants.ssoTokenKey)")
            } else {
                print("未能儲存 ssoStuNo。檢查 App Group 配置或鍵名。")
            }
        }
    }

    
    func logout() {
        appGroupDefaults?.removeObject(forKey: Constants.ssoTokenKey)
        appGroupDefaults?.removeObject(forKey: Constants.Courses)
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

