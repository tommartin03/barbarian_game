//
//  BarbarianRepository.swift
//  barbarian_game
//
//  Created by tplocal on 03/12/2025.
//
import Foundation


struct EmptyResponse: Decodable {}

class BarbarianRepository {
    //recuperation de son barbare
    func getMyBarbarian() async throws -> Barbarian {
        try await APIClient.shared.request(.get_my_barbarian, body: nil)
    }

    //création du babare
    func createBarbarian(name: String, avatarID: Int) async throws -> Barbarian {
        try await APIClient.shared.request(
            .create_or_reset_barbarian,
            body: ["name": name, "avatar_id": avatarID]
        )
    }
    
    //suprimer le babare
    func resetBarbarian(name: String) async throws {
            let body: [String: String] = ["name": name]
            
            let _: EmptyResponse = try await APIClient.shared.request(
                .create_or_reset_barbarian,
                body: body
            )
        }
    
    //modification des points de compétences
    func spendSkillPoints(
            attack: Int,
            defense: Int,
            accuracy: Int,
            evasion: Int
        ) async throws {
            let body: [String: Int] = [
                "attack": attack,
                "defense": defense,
                "accuracy": accuracy,
                "evasion": evasion
            ]

            //spécifier le type générique pour que Swift sache quoi décoder
            let _: EmptyResponse = try await APIClient.shared.request(
                .spend_skill_points,
                body: body
            )
        }
}

