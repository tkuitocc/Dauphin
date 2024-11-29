//
//  CoursesWidgetBundle.swift
//  CoursesWidget
//
//  Created by \u8b19 on 11/27/24.
//

import WidgetKit
import SwiftUI
import KeychainSwift

@main
struct CoursesWidgetBundle: WidgetBundle {
    var body: some Widget {
        CoursesNextUpWidget()
        CoursesWidgetControl()
    }
}
