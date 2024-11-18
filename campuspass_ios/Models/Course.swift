//
//  Course.swift
//  campuspass_ios
//
//  Created by \u8b19 on 11/17/24.
//

import Foundation
// MARK: - Course Model
struct Course: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var room: String
    var teacher: String
    var time: String
    var stdNo: String
}
