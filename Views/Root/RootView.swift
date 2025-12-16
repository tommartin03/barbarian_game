//
//  RootView.swift
//  barbarian_game
//
//  Created by tplocal on 11/12/2025.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var authVm: AuthViewModel
    @EnvironmentObject var barbarianVm: BarbarianViewModel
    
    @State private var isLoading = false

    var body: some View {
        // Conteneur principal qui change de vue
        Group {
            
            // Si utilisateur connecté
            if authVm.isAuthenticated {
                
                // Affichage loading
                if isLoading {
                    ProgressView("Chargement...")
                }
                
                // Si barbare existant
                else if let _ = barbarianVm.barbarian {
                    MenuView() // Affiche le menu principal
                }
                
                // Sinon création barbare
                else {
                    CreateBarbarianView() // Création du barbare
                }
                
            }
            
            // Sinon connexion
            else {
                LoginView() // Page de login
            }
        }
        // Tâche de chargement des données
        .task(id: authVm.isAuthenticated) {
            if authVm.isAuthenticated {
                await loadPlayerData() // Récupère avatars + barbare
            } else {
                barbarianVm.barbarian = nil // Reset barbare si déconnecté
            }
        }
    }
    
    // Fonction chargement données joueur
    private func loadPlayerData() async {
        isLoading = true
        
        await barbarianVm.loadAvatars()  // Charger avatars
        await barbarianVm.loadBarbarian() // Charger barbare actuel
        
        isLoading = false
    }
}
