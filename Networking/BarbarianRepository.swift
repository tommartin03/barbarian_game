//
//  BarbarianRepository.swift
//  barbarian_game
//
//  Created by tplocal on 03/12/2025.
//
import Foundation


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
}

