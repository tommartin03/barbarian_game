//
//  APIClient.swift
//  barbarian_game
//
//  Created by tplocal on 02/12/2025.
//

import Foundation

//classe responsable de toutes les requêtes HTTP vers l'API
class APIClient {
    // usage de APIClient.shared.request
    static let shared = APIClient()
    // constructeur privé pour forcer le singleton
    private init() {}

    func request<T: Decodable>(_ endpoint: APIEndpoints, body: [String: Any]? = nil) async throws -> T {
        
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = endpoint.method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = TokenManager.shared.token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        // préparation du body de la requete
        if let body = body,
           // convertir le dictionnaire swift en JSON
           let jsonData = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted),
           
            //affichage dans le terminal
            let jsonString = String(data: jsonData, encoding: .utf8) {
            print("➡️ Sending JSON body:")
            print(jsonString)
            request.httpBody = jsonData
        }
        //envoie de la requete
        let (data, response) = try await URLSession.shared.data(for: request)

        //affichage de la réponse dans le terminal
        if let httpResponse = response as? HTTPURLResponse {
            print("HTTP status code:", httpResponse.statusCode)
            print("Response body:", String(data: data, encoding: .utf8) ?? "<no body>")
        }
        
        //verification de la réponse, sans erreurs
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        
        guard 200..<300 ~= httpResponse.statusCode else {
            //decoder le message d'erreur du serveur
            if let serverError = try? JSONDecoder().decode(ServerErrorResponse.self, from: data) {
                throw APIError.serverError(message: serverError.error)
            } else {
                throw APIError.invalidResponse
            }
        }

        //décodage JSON du json et transformation en objet swift
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decodingError
        }
    }
}
