//
//  AuthViewModel.swift
//  barbarian_game
//
//  Created by tplocal on 02/12/2025.
//

import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var isAuthenticated = false
    @Published var isRegistered = false
    @Published var errorMessage = ""

    private let repository = AuthRepository()

    func login() async {
        errorMessage = ""

        do {
            let response = try await repository.login(username: username, password: password)

            if let token = response.token {
                TokenManager.shared.saveToken(token)
                isAuthenticated = true
            } else {
                errorMessage = response.message ?? "Identifiants invalides"
            }
        } catch let apiError as APIError {
            switch apiError {
            case .serverError(let message):
                errorMessage = message
            default:
                errorMessage = apiError.localizedDescription
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func register() async {
        errorMessage = ""

        do {
            let response = try await repository.register(username: username, password: password)

            if (response.status?.lowercased() ?? "") == "ok" {
                isRegistered = true
            } else {
                errorMessage = response.message ?? "Erreur lors de l’inscription"
            }
        } catch let apiError as APIError {      
            switch apiError {
            case .serverError(let message):
                if message == "username_exists" {
                    errorMessage = "Ce nom d’utilisateur existe déjà."
                } else {
                    errorMessage = message
                }
            default:
                errorMessage = apiError.localizedDescription
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func logout() async {
        do {
            try await repository.logout()
        } catch {
            print("Erreur lors de la déconnexion API: \(error)")
        }
        
        TokenManager.shared.clearToken()
        isAuthenticated = false
    }
}
