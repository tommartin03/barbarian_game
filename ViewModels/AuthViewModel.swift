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

    //se connecter
    func login() async {
        errorMessage = ""

        do {
            let response = try await repository.login(username: username, password: password)
            //enregistrement du token
            if let token = response.token {
                TokenManager.shared.saveToken(token)
                isAuthenticated = true
            } else {
                errorMessage = response.message ?? "Identifiants invalides"
            }
            //gestion des erreurs si la réquete envoie une erreur
        } catch let apiError as APIError {
            switch apiError {
            case .serverError(let message):
                if message == "invalid_credentials" {
                    errorMessage = "Identifiants invalides."
                }
                else {
                        errorMessage = message
                    }
            default:
                errorMessage = apiError.localizedDescription
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    //s'enregistrer
    func register() async {
        errorMessage = ""

        do {
            let response = try await repository.register(username: username, password: password)
            //mise à jour du status de connection
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
    //deconnexion
    func logout() async {
        do {
            try await repository.logout()
        } catch {
            print("Erreur lors de la déconnexion API: \(error)")
        }
        //nettoyage du token
        TokenManager.shared.clearToken()
        isAuthenticated = false
    }
}
