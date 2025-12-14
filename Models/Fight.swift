//
//  Fight.swift
//  barbarian_game
//
//  Created by tplocal on 11/12/2025.
//

import Foundation

// Réponse complète d'un combat
struct FightResponse: Codable {
    let opponent: Barbarian
    let winner_id: Int
    let exp_gain: Int
    let log: FightLog
}

// Structure du log de combat
struct FightLog: Codable {
    let attacker_id: Int
    let defender_id: Int
    let rounds: [FightRound]
}

// Un round de combat
struct FightRound: Codable, Identifiable {
    let round: Int
    let actor: Int
    let target: Int
    let hit: Bool
    let damage: Int
    let hp_target_after: Int
    
    var id: String {
        "\(round)-\(actor)-\(target)"
    }
}

struct FightHistoryEntry: Codable, Identifiable {
    let id: Int
    let attacker_id: Int
    let defender_id: Int
    let winner_id: Int
    let created_at: String
    let exp_attacker: Int
    let exp_defender: Int
    let log: FightLog
    
    // propriétés qui ne vienne pas de l'api
    var attackerName: String?
    var defenderName: String?
    var attackerAvatarId: Int?  
    var defenderAvatarId: Int?
    
    //eviter les bugs avec les propritétées qui ne viennent pas de l'api, elles ne seront pas décodé
    enum CodingKeys: String, CodingKey {
        case id, attacker_id, defender_id, winner_id, created_at, exp_attacker, exp_defender, log
    }

}
