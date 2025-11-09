//
//  AppSettings.swift
//  SemesterProject
//
//  Created by mfisman on 08.11.2025.
//

import Foundation
import SwiftData

@Model
class AppSettings {
    var backgroundColorName: String
    
    init() {
        self.backgroundColorName = "systemBackground"
    }
    
    init(backgroundColorName: String) {
        self.backgroundColorName = backgroundColorName
    }
}
