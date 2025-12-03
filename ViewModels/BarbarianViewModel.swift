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

    func avatarURL(for bar: Barbarian) -> URL {
        if let avatar = avatars.first(where: { $0.id == bar.avatar_id }) {
            return avatar.fullURL
        }
        // fallback si pas trouvé
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

    // Déconnexion
    func logout() {
        barbarian = nil
        // Supprimer token stocké si besoin
    }
}
