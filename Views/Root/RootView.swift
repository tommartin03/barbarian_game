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
                        .task {
                            await loadData()
                        }
                } else if let _ = barbarianVm.barbarian {
                    MenuView()
                } else {
                    CreateBarbarianView()
                }
            } else {
                LoginView()
            }
        }
    }

    func loadData() async {
        isLoading = true
        // Charge avatars et barbare
        async let _ = barbarianVm.loadAvatars()
        async let bar = barbarianVm.loadBarbarian() // si pas de barbare, renvoie nil

        _ = try? await bar
        isLoading = false
    }
}

