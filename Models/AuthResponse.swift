//
//  AuthResponse.swift
//  barbarian_game
//
//  Created by tplocal on 02/12/2025.
//

struct AuthResponse: Codable {
    let status: String?
    let token: String?      // token uniquement pour login
    let message: String?    // message d'erreur éventuel
}
