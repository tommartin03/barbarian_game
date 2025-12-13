//
//  BarbarianViewModel.swift
//  barbarian_game
//
//  Created by tplocal on 03/12/2025.
//
import SwiftUI

@MainActor
class BarbarianViewModel: ObservableObject {
    @Published var barbarian: Barbarian? = nil
    @Published var avatars: [Avatar] = []
    @Published var isLoading = false
    @Published var isUpdating = false // Pour gérer le loader sur ajout de point
    

    private let barbarianRepo = BarbarianRepository()
    private let avatarRepo = AvatarRepository()

    // Charger le barbare existant
    @MainActor
    func loadBarbarian() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let bar = try await barbarianRepo.getMyBarbarian()
            self.barbarian = bar
        } catch {
            print("Erreur en chargeant le barbare :", error)
            self.barbarian = nil
        }
    }

    // Charger la liste des avatars
    func loadAvatars() async {
        do {
            let allAvatars = try await avatarRepo.getAvatars()
            self.avatars = allAvatars
        } catch {
            print("Erreur en chargeant les avatars :", error)
        }
    }

    func avatarURL(avatarID: Int) -> URL {
        if let avatar = avatars.first(where: { $0.id == avatarID }) {
            return avatar.fullURL
        }
        return URL(string: "https://vps.vautard.fr/barbarians/avatars/default.png")!
    }

    // Créer un nouveau barbare
    func createBarbarian(name: String, avatarID: Int) async {
        do {
            try await barbarianRepo.createBarbarian(name: name, avatarID: avatarID)
            await loadBarbarian()
        } catch {
            print("Erreur création barbare :", error)
        }
    }

    //  Ajouter un point de compétence
    func addPoint(to stat: String) {
        guard let bar = barbarian, bar.skill_points > 0 else { return }
        isUpdating = true
        
        Task {
            var attack = 0
            var defense = 0
            var accuracy = 0
            var evasion = 0
            
            switch stat {
            case "attack": attack = 1
            case "defense": defense = 1
            case "accuracy": accuracy = 1
            case "evasion": evasion = 1
            default: break
            }
            
            do {
                try await barbarianRepo.spendSkillPoints(
                    attack: attack,
                    defense: defense,
                    accuracy: accuracy,
                    evasion: evasion
                )
                // Recharger le barbare pour mettre à jour les stats et skill_points
                let updatedBar = try await barbarianRepo.getMyBarbarian()
                self.barbarian = updatedBar
            } catch {
                print("Erreur lors de l'ajout d'un point :", error)
            }
            
            isUpdating = false
        }
    }
}
