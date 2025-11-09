//
//  NewSubjectView.swift
//  SemesterProject
//
//  Created by mfisman on 08.11.2025.
//

import SwiftUI

struct NewSubjectView: View {
    @State private var name: String = ""
    var onSave: (String) -> Void
    @Environment(\.presentationMode) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Название предмета")) {
                    TextField("Например: Физика", text: $name)
                }
            }
            .navigationTitle("Новый предмет")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !trimmed.isEmpty else { return }
                        onSave(trimmed)
                        dismiss.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") { dismiss.wrappedValue.dismiss() }
                }
            }
        }
    }
}

