//
//  SubjectsListView.swift
//  SemesterProject
//
//  Created by mfisman on 08.11.2025.
//

import SwiftUI

struct SubjectsListView: View {
    @EnvironmentObject var vm: AppViewModel
    @State private var showingNew = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.subjects) { sub in
                    HStack {
                        Text(sub.name)
                        Spacer()
                        if vm.studySubjectID == sub.id {
                            Label("Текущий", systemImage: "target")
                                .font(.caption)
                                .foregroundColor(.accentColor)
                        }
                    }
                }
                .onDelete(perform: vm.deleteSubject)
            }
            .scrollContentBackground(.hidden)
            .background(vm.colorForName(vm.settings.backgroundColorName))
            .navigationTitle("Предметы")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingNew = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNew) {
                NewSubjectView { name in
                    vm.addSubject(name: name)
                    showingNew = false
                }
            }
        }
    }
}
