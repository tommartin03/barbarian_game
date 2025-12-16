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
        // conteneur principal qui change de vue
        Group {
            
            //si utilisateur connecté
            if authVm.isAuthenticated {
                
                //affichage loading
                if isLoading {
                    ProgressView("Chargement...")
                }
                
                //si barbare existant
                else if let _ = barbarianVm.barbarian {
                    MenuView() // affiche le menu principal
                }
                
                //sinon création barbare
                else {
                    CreateBarbarianView() // création du barbare
                }
                
            }
            
            //sinon connexion
            else {
                LoginView() //page de login
            }
        }
        //tâche de chargement des données
        .task(id: authVm.isAuthenticated) {
            if authVm.isAuthenticated {
                await loadPlayerData() //récupère avatars + barbare
            } else {
                barbarianVm.barbarian = nil //reset barbare si déconnecté
            }
        }
    }
    
    //fonction chargement données joueur
    private func loadPlayerData() async {
        isLoading = true
        
        await barbarianVm.loadAvatars()  //charger avatars
        await barbarianVm.loadBarbarian() //charger barbare actuel
        
        isLoading = false
    }
}
