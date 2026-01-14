//
//  SemesterProjectApp.swift
//  SemesterProject
//
//  Created by mfisman on 08.11.2025.
//

import SwiftUI
import SwiftData

@main
struct SemesterProjectApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: [Subject.self, SessionRecord.self, AppSettings.self])
    }
}

struct RootView : View {
    @Environment(\.modelContext) private var context
    
    var body: some View {
        ContentView()
            .environmentObject(AppViewModel(context: context))
            .preferredColorScheme(.light)
    }
}
