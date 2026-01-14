//
//  HistoryView.swift
//  SemesterProject
//
//  Created by mfisman on 08.11.2025.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var vm: AppViewModel
    
    var body: some View {
        NavigationView {
            List {
                if vm.sessions.isEmpty {
                    Text("История пуста")
                } else {
                    ForEach(vm.sessions) { s in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(s.subjectName)
                                    .font(.headline)
                                Spacer()
                                Text(formatDuration(s.duration))
                                    .font(.subheadline)
                            }
                            Text("\(dateFormatter.string(from: s.start)) — \(dateFormatter.string(from: s.end))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 6)
                    }
                    .onDelete(perform: delete)
                }
            }
            .scrollContentBackground(.hidden)
            .background(vm.colorForName(vm.settings.backgroundColorName))
            .navigationTitle("История сессий")
        }
    }
    
    private func delete(at offsets: IndexSet) {
        vm.sessions.remove(atOffsets: offsets)
        vm.saveAll()
    }
    
    private func formatDuration(_ sec: TimeInterval) -> String {
        let total = Int(sec)
        let h = total / 3600
        let m = (total % 3600) / 60
        let s = (total % (3600 * 60))
        if h > 0 {
            return String(format: "%dh %02dm", h, m)
        } else {
            return String(format: "%dm %ds", m, s)
        }
    }
    
    private var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateStyle = .short
        f.timeStyle = .medium
        return f
    }
}
