//
//  Barbarian.swift
//  barbarian_game
//
//  Created by tplocal on 03/12/2025.
//
import SwiftUI

struct Barbarian: Codable {
    let id: Int
    let name: String
    let avatar_id: Int
    let love: Int
    let exp: Int
    var skill_points: Int
    let attack: Int
    let defense: Int
    let accuracy: Int
    let evasion: Int
    let hp_max: Int
    let created_at: String
    let last_fight_at: String?
    
    var avatarURL: URL {
        URL(string: "https://vps.vautard.fr/barbarians/avatars/a\(avatar_id).png")!
    }
}
