//
//  ContentView.swift
//  SemesterProject
//
//  Created by mfisman on 08.11.2025.
//

import SwiftUI
import SwiftData


struct ContentView: View {
    @EnvironmentObject var vm: AppViewModel
    
    var body: some View {
        TabView {
            TimerView()
                .tabItem {
                    Label("Таймер", systemImage: "timer")
                }
                .background(vm.colorForName(vm.settings.backgroundColorName))
            SubjectsListView()
                .tabItem {
                    Label("Предметы", systemImage: "list.bullet")
                }
            StatisticsUIKitWrapper()
                .tabItem {
                    Label("Статистика", systemImage: "chart.bar")
                }
                .background(vm.colorForName(vm.settings.backgroundColorName))
            HistoryView()
                .tabItem {
                    Label("История", systemImage: "clock.arrow.circlepath")
                }
            SettingsView()
                .tabItem {
                    Label("Настройки", systemImage: "gear")
                }
        }
    }
}

#Preview {
    let container = try! ModelContainer(
        for: Subject.self, SessionRecord.self, AppSettings.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    let context = ModelContext(container)

    let math = Subject(name: "Математика")
    let prog = Subject(name: "Программирование")
    let settings = AppSettings(backgroundColorName: "systemBackground")
    context.insert(math)
    context.insert(prog)
    context.insert(settings)

    let vm = AppViewModel(context: context)

    return ContentView()
        .environmentObject(vm)
}
