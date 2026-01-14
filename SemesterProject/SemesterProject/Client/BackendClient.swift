//
//  BackendClient.swift
//  SemesterProject
//
//  Created by mfisman on 09.11.2025.
//

import Foundation
import Combine

final class BackendClient: ObservableObject {
    private let baseURL = "http://localhost:5000"
    
    func fetchMotivationalText(for mode: TimerMode) -> AnyPublisher<String, Never> {
        let endpoint = mode == .study ? "study" : "rest"
        let urlString = "\(baseURL)/api/motivation/\(endpoint)"
        
        guard let url = URL(string: urlString) else {
            return Just(getFallbackText(for: mode))
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MotivationResponse.self, decoder: JSONDecoder())
            .map(\.text)
            .catch { _ in
                Just(self.getFallbackText(for: mode))
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func getFallbackText(for mode: TimerMode) -> String {
        if mode == .study {
            return "Сосредоточься на задаче. Маленькие шаги каждый день — большой прогресс."
        } else {
            return "Отличная работа! Немного отдыха — и можно снова в бой."
        }
    }
}
