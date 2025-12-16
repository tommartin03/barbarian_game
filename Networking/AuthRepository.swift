//
//  AuthRepository.swift
//  barbarian_game
//
//  Created by tplocal on 02/12/2025.
//

import Foundation

class AuthRepository {
    //s'inscrire
    func register(username: String, password: String) async throws -> AuthResponse {
        try await APIClient.shared.request(
            .register,
            body: ["username": username, "password": password]
        )
    }

    //se connecter
    func login(username: String, password: String) async throws -> AuthResponse {
        try await APIClient.shared.request(
            .login,
            body: ["username": username, "password": password]
        )
    }
    
    //se déconnecter
    func logout() async throws -> AuthResponse {
            try await APIClient.shared.request(.logout)
        }
}


