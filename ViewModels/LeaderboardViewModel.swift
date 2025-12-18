//
//  LeaderBoardViewModel.swift
//  barbarian_game
//
//  Created by tplocal on 12/12/2025.
//

import SwiftUI
import Foundation

@MainActor
class LeaderboardViewModel: ObservableObject {
    @Published var leaders: [LeaderboardBarbarian] = []
    @Published var isLoading = false
    @Published var errorMessage = ""

    func loadLeaderboard() async {
        
        //création et récupération du classement
        do {
            let repo = LeaderboardRepository()
            let result = try await repo.getLeaderboard()

            //trie en fonction du love puis le l'xp
            leaders = result.sorted {
                if $0.love == $1.love {
                    return $0.exp > $1.exp
                }
                return $0.love > $1.love
            }
        } catch {
            errorMessage = error.localizedDescription
            print("Erreur leaderboard :", error)
        }
    }
}

