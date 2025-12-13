//
//  FightViewModel.swift
//  barbarian_game
//
//  Created by tplocal on 12/12/2025.
//

import SwiftUI

@MainActor
class FightViewModel: ObservableObject {
    @Published var currentFight: FightResponse?
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    private let repository = FightRepository()
    
    // Lancer un combat
    func startFight() async -> Bool {
        isLoading = true
        errorMessage = ""
        
        do {
            let response = try await repository.startFight()
            currentFight = response
            isLoading = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
    
    // Réinitialiser le combat
    func resetFight() {
        currentFight = nil
        errorMessage = ""
    }
}
