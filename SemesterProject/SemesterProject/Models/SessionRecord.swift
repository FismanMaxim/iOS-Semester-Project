//
//  SessionRecord.swift
//  SemesterProject
//
//  Created by mfisman on 08.11.2025.
//

import Foundation
import SwiftData

@Model
class SessionRecord: Identifiable {
    var id: UUID = UUID()
    var subjectID: UUID?
    var subjectName: String
    var start: Date
    var end: Date
    
    var duration: TimeInterval { end.timeIntervalSince(start) }
    
    init(subjectID: UUID?, subjectName: String, start: Date, end: Date) {
        self.subjectID = subjectID
        self.subjectName = subjectName
        self.start = start
        self.end = end
    }
    
    init(id: UUID, subjectID: UUID?, subjectName: String, start: Date, end: Date) {
        self.id = id
        self.subjectID = subjectID
        self.subjectName = subjectName
        self.start = start
        self.end = end
    }
}
