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
    case create_or_reset_barbarian
    case get_my_barbarian
    case get_avatars
    case spend_skill_points
    case logout
    case fight

    var url: URL {
        switch self {
        case .register:
            return URL(string: "https://vps.vautard.fr/barbarians/ws/register.php")!
        case .login:
            return URL(string: "https://vps.vautard.fr/barbarians/ws/login.php")!
        case .logout:
            return URL(string: "https://vps.vautard.fr/barbarians/ws/logout.php")!
        case .create_or_reset_barbarian:
            return URL(string: "https://vps.vautard.fr/barbarians/ws/create_or_reset_barbarian.php")!
        case .get_my_barbarian:
            return URL(string: "https://vps.vautard.fr/barbarians/ws/get_my_barbarian.php")!
        case .get_avatars:
            return URL(string: "https://vps.vautard.fr/barbarians/ws/avatars.php")!
        case .spend_skill_points:
            return URL(string: "https://vps.vautard.fr/barbarians/ws/spend_skill_points.php")!
        case .fight:
            return URL(string: "https://vps.vautard.fr/barbarians/ws/fight.php")!
        }
    }

    var method: String {
        switch self {
        case .register, .login, .logout, .create_or_reset_barbarian, .spend_skill_points:
            return "POST"
        case .get_my_barbarian, .get_avatars, .fight:
            return "GET"
        }
    }
}
