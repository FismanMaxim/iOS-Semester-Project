//
//  StatisticsViewUIKitWrapper.swift
//  SemesterProject
//
//  Created by mfisman on 09.11.2025.
//

import SwiftUI

struct StatisticsUIKitWrapper: UIViewControllerRepresentable {
    @EnvironmentObject var vm: AppViewModel
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return StatisticsViewController(viewModel: vm)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
