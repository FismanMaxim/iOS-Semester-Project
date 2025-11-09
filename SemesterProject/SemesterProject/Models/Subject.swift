//
//  Subject.swift
//  SemesterProject
//
//  Created by mfisman on 08.11.2025.
//

import Foundation
import SwiftData

@Model
class Subject: Identifiable, Equatable {
    var id: UUID
    var name: String
    
    init(name: String) {
        self.id = UUID()
        self.name = name
    }
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}
