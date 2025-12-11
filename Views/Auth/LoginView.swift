//
//  LoginView.swift
//  barbarian_game
//
//  Created by tplocal on 02/12/2025.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authVm: AuthViewModel
    @EnvironmentObject var barbarianVm: BarbarianViewModel
    @State private var navigateToNext = false
    @State private var nextDestination: AnyView = AnyView(EmptyView())

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                TextField("Username", text: $authVm.username)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                    .autocorrectionDisabled(true)

                SecureField("Password", text: $authVm.password)
                    .textFieldStyle(.roundedBorder)

                if !authVm.errorMessage.isEmpty {
                    Text(authVm.errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }

                Button("Login") {
                    Task {
                        await authVm.login()
                        if authVm.isAuthenticated {
                            // Charger le barbare existant
                            await barbarianVm.loadBarbarian()

                            // Afficher dans la console ce qui a été chargé
                            if let barbarian = barbarianVm.barbarian {
                                print("Barbare chargé :", barbarian)
                            } else {
                                print("Aucun barbare trouvé")
                            }

                            // Déterminer la vue suivante
                            if let _ = barbarianVm.barbarian {
                                nextDestination = AnyView(MenuView())
                            } else {
                                nextDestination = AnyView(CreateBarbarianView())
                            }

                            navigateToNext = true
                        }
                    }
                }

                NavigationLink("Register", destination: RegisterView())

                // Navigation dynamique vers la vue suivante
                NavigationLink(
                    destination: nextDestination,
                    isActive: $navigateToNext,
                    label: { EmptyView() }
                )
            }
            .padding()
        }
    }
}
