//
//  APIClient.swift
//  barbarian_game
//
//  Created by tplocal on 02/12/2025.
//

import Foundation

class APIClient {
    static let shared = APIClient()
    private init() {}

    func request<T: Decodable>(_ endpoint: APIEndpoints, body: [String: Any]? = nil) async throws -> T {
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = endpoint.method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = TokenManager.shared.token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        // Log JSON envoyé
        if let body = body,
           let jsonData = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print("➡️ Sending JSON body:")
            print(jsonString)
            request.httpBody = jsonData
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        // Log réponse
        if let httpResponse = response as? HTTPURLResponse {
            print("HTTP status code:", httpResponse.statusCode)
            print("Response body:", String(data: data, encoding: .utf8) ?? "<no body>")
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        // Si code HTTP non 2xx
        guard 200..<300 ~= httpResponse.statusCode else {
            if let serverError = try? JSONDecoder().decode(ServerErrorResponse.self, from: data) {
                throw APIError.serverError(message: serverError.error)
            } else {
                throw APIError.invalidResponse
            }
        }

        // Décodage JSON
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decodingError
        }
    }
}
