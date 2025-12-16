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
    
    //charger l'historique
    func loadHistory() async {
        isLoading = true
        //création de l'hitorique et gestion de la réponse
        do {
            let repo = FightRepository()
            history = try await repo.getFightHistory() ?? []
            await loadBarbarianNames()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    //enrichit chaque combat de l'historique avec les noms et avatars des barbares
    private func loadBarbarianNames() async {
        for i in 0..<history.count {
            let entry = history[i]
            
            //récupréation des noms et des avatars de l'attaquant
            do {
                let attacker: Barbarian = try await APIClient.shared.request(.get_barbarian(id: entry.attacker_id))
                history[i].attackerName = attacker.name
                history[i].attackerAvatarId = attacker.avatar_id
            } catch {
                print("Erreur chargement attaquant \(entry.attacker_id):", error)
            }
            //récupréation des noms et des avatars du defenseur
            do {
                let defender: Barbarian = try await APIClient.shared.request(.get_barbarian(id: entry.defender_id))
                history[i].defenderName = defender.name
                history[i].defenderAvatarId = defender.avatar_id
            } catch {
                print("Erreur chargement défenseur \(entry.defender_id):", error)
            }
        }
    }
    
    //lance la vérification régulière uniquement si l'app est visible
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
    
    //vérifie si un nouveau combat est apparu
    private func checkForNewFights() async {
        do {
            let repo = FightRepository()
            let latestHistory = try await repo.getFightHistory() ?? []
            if let lastFight = latestHistory.first, lastFight.id != history.first?.id {
                history = latestHistory
                await loadBarbarianNames()
                newFightNotification = lastFight
            }
        } catch {
            print("Erreur lors de la vérification des combats : \(error)")
        }
    }
}
