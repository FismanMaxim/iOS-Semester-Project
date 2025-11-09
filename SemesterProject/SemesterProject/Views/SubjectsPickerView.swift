//
//  SubjectsPickerView.swift
//  SemesterProject
//
//  Created by mfisman on 08.11.2025.
//

import SwiftUI

struct SubjectsPickerView: View {
    @EnvironmentObject var vm: AppViewModel
    @Binding var selectedID: UUID?
    @Environment(\.presentationMode) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Button(action: {
                    selectedID = nil
                }) {
                    HStack {
                        Text("Без предмета")
                        Spacer()
                        if selectedID == nil { Image(systemName: "checkmark") }
                    }
                }
                ForEach(vm.subjects) { subject in
                    Button(action: {
                        selectedID = subject.id
                    }) {
                        HStack {
                            Text(subject.name)
                            Spacer()
                            if selectedID == subject.id {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Выбрать предмет")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Готово") {
                        if let id = selectedID, let s = vm.subjects.first(where: { $0.id == id }) {
                            vm.selectSubject(s)
                        } else {
                            vm.selectSubject(nil)
                        }
                        dismiss.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
