//
//  BarbarianRepository.swift
//  barbarian_game
//
//  Created by tplocal on 03/12/2025.
//
import Foundation


struct EmptyResponse: Decodable {}

class BarbarianRepository {
    func getMyBarbarian() async throws -> Barbarian {
        try await APIClient.shared.request(.get_my_barbarian, body: nil)
    }

    func createBarbarian(name: String, avatarID: Int) async throws -> Barbarian {
        try await APIClient.shared.request(
            .create_or_reset_barbarian,
            body: ["name": name, "avatar_id": avatarID]
        )
    }
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

            // Spécifier le type générique pour que Swift sache quoi décoder
            let _: EmptyResponse = try await APIClient.shared.request(
                .spend_skill_points,
                body: body
            )
        }
}

