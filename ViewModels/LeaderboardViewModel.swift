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

    private var timer: Timer?

    func loadLeaderboard() async {
        isLoading = true
        defer { isLoading = false }

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
            errorMessage = error.localizedDescription
            print("Erreur leaderboard :", error)
        }
    }

    //  Rafraîchissement automatique
    func startMonitoring(interval: TimeInterval = 15) {
        stopMonitoring()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            Task {
                await self?.loadLeaderboard()
            }
        }
    }

    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }
}

