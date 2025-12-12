//
//  FightViewModel.swift
//  barbarian_game
//
//  Created by tplocal on 12/12/2025.
//

import SwiftUI

@MainActor
class FightHistoryViewModel: ObservableObject {
    @Published var history: [FightHistoryEntry] = []
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var newFightNotification: FightHistoryEntry? = nil
    
    private var timer: Timer?
    
    func loadHistory() async {
        isLoading = true
        do {
            let repo = FightRepository()
            history = try await repo.getFightHistory() ?? []
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    /// Lance la vérification régulière uniquement si l'app est visible
    func startMonitoring(interval: TimeInterval = 15) {
        stopMonitoring()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            Task {
                await self?.checkForNewFights()
            }
        }
    }
    
    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }
    
    /// Vérifie si un nouveau combat est apparu
    private func checkForNewFights() async {
        do {
            let repo = FightRepository()
            let latestHistory = try await repo.getFightHistory() ?? []
            if let lastFight = latestHistory.first, lastFight.id != history.first?.id {
                history = latestHistory
                newFightNotification = lastFight
            }
        } catch {
            print("Erreur lors de la vérification des combats : \(error)")
        }
    }
}
