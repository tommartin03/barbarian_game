//
//  LeaderboardBarbarian.swift
//  barbarian_game
//
//  Created by tplocal on 12/12/2025.
//

struct LeaderboardBarbarian: Codable, Identifiable {
    let id: Int
    let name: String
    let avatar_id: Int
    let love: Int
    let exp: Int
    let attack: Int
    let defense: Int
    let accuracy: Int
    let evasion: Int
}
