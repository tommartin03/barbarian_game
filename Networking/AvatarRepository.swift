//
//  AvatarRepository.swift
//  barbarian_game
//
//  Created by tplocal on 03/12/2025.
//
import SwiftUI

struct Avatar: Codable, Identifiable {
    let id: Int
    let image_path: String

    //url de base
    var fullURL: URL {
        URL(string: "https://vps.vautard.fr/" + image_path)!
    }
}   


class AvatarRepository {
    //recuperation de l'avatar
    func getAvatars() async throws -> [Avatar] {
        try await APIClient.shared.request(.get_avatars, body: nil as [String: Any]?)
    }
}
