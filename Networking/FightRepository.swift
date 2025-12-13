//
//  FightRepository.swift
//  barbarian_game
//
//  Created by tplocal on 11/12/2025.
//

import Foundation

class FightRepository {
    func startFight() async throws -> FightResponse {
        try await APIClient.shared.request(.fight)
    }
    func getFightHistory() async throws -> [FightHistoryEntry] {
        try await APIClient.shared.request(.get_fight_history)
    }
}
