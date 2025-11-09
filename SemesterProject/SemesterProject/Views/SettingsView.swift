//
//  SettingsView.swift
//  SemesterProject
//
//  Created by mfisman on 08.11.2025.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var vm: AppViewModel
    @State private var confirmReset = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Фон приложения")) {
                    Picker("Фон", selection: $vm.settings.backgroundColorName) {
                        ForEach(vm.availableBackgrounds, id: \.self) { name in
                            HStack {
                                Text(name)
                                Spacer()
                                Circle()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(vm.colorForName(name))
                            }
                            .tag(name)
                        }
                    }
                    .onChange(of: vm.settings.backgroundColorName) { _, new in
                        vm.setBackground(name: new)
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        confirmReset = true
                    } label: {
                        Text("Сбросить прогресс")
                    }
                    .confirmationDialog("Удалить все данные?", isPresented: $confirmReset, titleVisibility: .visible) {
                        Button("Удалить всё", role: .destructive) {
                            vm.resetAllData()
                        }
                        Button("Отмена", role: .cancel) {}
                    } message: {
                        Text("Это действие удалит все предметы и историю сессий.")
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(vm.colorForName(vm.settings.backgroundColorName))
            .navigationTitle("Настройки")
        }
    }
}
