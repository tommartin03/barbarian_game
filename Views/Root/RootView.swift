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
        Group {
            if authVm.isAuthenticated {
                if isLoading {
                    ProgressView("Chargement...")
                }
                else if let _ = barbarianVm.barbarian {
                    MenuView()
                }
                else {
                    CreateBarbarianView()
                }
                
            } else {
                LoginView()
            }
        }
        .task(id: authVm.isAuthenticated) {
            if authVm.isAuthenticated {
                await loadPlayerData()
            } else {
                barbarianVm.barbarian = nil
            }
        }
    }
    
    private func loadPlayerData() async {
        isLoading = true
        
        await barbarianVm.loadAvatars()
        await barbarianVm.loadBarbarian()
        
        isLoading = false
    }
}
