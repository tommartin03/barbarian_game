//
//  TokenManager.swift
//  barbarian_game
//
//  Created by tplocal on 02/12/2025.
//

import Foundation

class TokenManager {
    static let shared = TokenManager()
    
    //singleton
    private init() {}

    private let key = "authToken"

    //création du token
    var token: String? {
        UserDefaults.standard.string(forKey: key)
    }
    
    //enregistrement du token
    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: key)
    }

    //netoyage du token
    func clearToken() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}

