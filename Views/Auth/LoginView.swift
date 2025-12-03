//
//  LoginView.swift
//  barbarian_game
//
//  Created by tplocal on 02/12/2025.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var authVM = AuthViewModel()
    @StateObject private var barbarianVM = BarbarianViewModel()
    @State private var navigateToNext = false
    @State private var nextDestination: AnyView = AnyView(EmptyView())

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                TextField("Username", text: $authVM.username)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                    .autocorrectionDisabled(true)

                SecureField("Password", text: $authVM.password)
                    .textFieldStyle(.roundedBorder)

                if !authVM.errorMessage.isEmpty {
                    Text(authVM.errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }

                Button("Login") {
                    Task {
                        await authVM.login()
                        if authVM.isAuthenticated {
                            // Charger le barbare existant
                            await barbarianVM.loadBarbarian()

                            // Afficher dans la console ce qui a été chargé
                            if let barbarian = barbarianVM.barbarian {
                                print("Barbare chargé :", barbarian)
                            } else {
                                print("Aucun barbare trouvé")
                            }

                            // Déterminer la vue suivante
                            if let _ = barbarianVM.barbarian {
                                nextDestination = AnyView(MenuView().environmentObject(barbarianVM))
                            } else {
                                nextDestination = AnyView(CreateBarbarianView().environmentObject(barbarianVM))
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
