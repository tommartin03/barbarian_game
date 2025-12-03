//
//  TokenManager.swift
//  barbarian_game
//
//  Created by tplocal on 02/12/2025.
//

import Foundation

class TokenManager {
    static let shared = TokenManager()
    private init() {}

    private let key = "authToken"

    var token: String? {
        UserDefaults.standard.string(forKey: key)
    }

    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: key)
    }

    func clearToken() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}

