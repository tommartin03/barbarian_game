//
//  LeaderBoardViewModel.swift
//  barbarian_game
//
//  Created by tplocal on 12/12/2025.
//

import SwiftUI

@MainActor
class LeaderboardViewModel: ObservableObject {
    @Published var leaders: [LeaderboardBarbarian] = []

    func loadLeaderboard() async {
        do {
            let repo = LeaderboardRepository()
            let result = try await repo.getLeaderboard()

            // Tri LOVE puis EXP
            leaders = result.sorted {
                if $0.love == $1.love {
                    return $0.exp > $1.exp
                }
                return $0.love > $1.love
            }

        } catch {
            print("Erreur leaderboard :", error)
        }
    }
}

