//
//  TimerView.swift
//  SemesterProject
//
//  Created by mfisman on 08.11.2025.
//

import SwiftUI

struct TimerView: View {
    @EnvironmentObject var vm: AppViewModel
    @State private var showSubjectsPicker = false
    @State private var animatePulse = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 150)
            
            VStack(spacing: 4) {
                Text(vm.timerMode == .study ? "Учеба" : "Отдых")
                    .font(.title)
                    .bold()
                Text(vm.subjectNameForCurrent() ?? vm.studySubjectName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
                .frame(height: 40)
            
            Text(TimeUtil.timeString(from: vm.remainingSeconds))
                .font(.system(size: 64, weight: .semibold, design: .rounded))
                .scaleEffect(animatePulse ? 1.025 : 1.0)
                .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: animatePulse)
                .onAppear { animatePulse = true }
            
            Spacer()
                .frame(height: 40)
            
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle())
                .padding(.horizontal, 40)
            
            Spacer()
                .frame(height: 40)
            
            Text(vm.motivationalText)
                .onAppear {
                    vm.loadMotivationalText()
                }
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            Spacer()
            HStack(spacing: 16) {
                Button(action: {
                    showSubjectsPicker = true
                }) {
                    HStack {
                        Image(systemName: "person.crop.square")
                        Text("Выбрать предмет")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .sheet(isPresented: $showSubjectsPicker) {
                    SubjectsPickerView(selectedID: $vm.studySubjectID)
                        .environmentObject(vm)
                }
                
                Button(action: {
                    if vm.timerMode == .study {
                        vm.finishStudy()
                    } else {
                        vm.continueStudy()
                    }
                }) {
                    Text(vm.timerMode == .study ? "Завершить обучение" : "Продолжить обучение")
                        .bold()
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
        .padding()
    }
    
    private var progress: Double {
        let total = vm.timerMode == .study ? Double(vm.studyDuration) : Double(vm.restDuration)
        return max(0.0, Double(vm.remainingSeconds) / total)
    }
}
