//
//  APIEndpoints.swift
//  barbarian_game
//
//  Created by tplocal on 02/12/2025.
//

import Foundation

enum APIEndpoints {
    case register
    case login

    var url: URL {
        switch self {
        case .register:
            return URL(string: "https://vps.vautard.fr/barbarians/ws/register.php")!
        case .login:
            return URL(string: "https://vps.vautard.fr/barbarians/ws/login.php")!
        }
    }

    var method: String {
        return "POST" // Les deux endpoints sont en POST
    }
}
