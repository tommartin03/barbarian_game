//
//  LeaderBoard.swift
//  barbarian_game
//
//  Created by tplocal on 12/12/2025.
//
import Foundation

class LeaderboardRepository {
    //récupération du leaderborad
    func getLeaderboard() async throws -> [LeaderboardBarbarian] {
        try await APIClient.shared.request(.leaderboard, body: nil as [String: Any]?)
    }
}


