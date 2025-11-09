//
//  TimeUtil.swift
//  SemesterProject
//
//  Created by mfisman on 08.11.2025.
//

import Foundation

class TimeUtil {
    static func timeString(from seconds: Int) -> String {
        let s = max(0, seconds)
        let min = s / 60
        let sec = s % 60
        return String(format: "%02d:%02d", min, sec)
    }
}
