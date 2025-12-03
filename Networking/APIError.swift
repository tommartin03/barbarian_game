//
//  APIError.swift
//  barbarian_game
//
//  Created by tplocal on 02/12/2025.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError
    case serverError(message: String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL invalide."
        case .invalidResponse:
            return "Réponse du serveur invalide."
        case .decodingError:
            return "Erreur de décodage des données."
        case .serverError(let message):
            return message
        }
    }
}
