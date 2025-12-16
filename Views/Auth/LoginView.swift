//
//  LoginView.swift
//  barbarian_game
//
//  Created by tplocal on 02/12/2025.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authVm: AuthViewModel

    var body: some View {
        // Navigation principale
        NavigationStack {
            
            // Conteneur principal
            VStack(spacing: 0) {
                Spacer()
                
                // Titre du jeu
                Text("Barbarian Game")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 50)
                
                // Formulaire de connexion
                VStack(spacing: 15) {
                    
                    // Champ nom utilisateur
                    TextField("Username", text: $authVm.username)
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                        .autocorrectionDisabled(true)

                    // Champ mot de passe
                    SecureField("Password", text: $authVm.password)
                        .textFieldStyle(.roundedBorder)

                    // Message erreur authentification
                    if !authVm.errorMessage.isEmpty {
                        Text(authVm.errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.horizontal, 30)
                
                // Boutons actions utilisateur
                VStack(spacing: 12) {
                    
                    // Bouton connexion API
                    Button {
                        Task { await authVm.login() }
                    } label: {
                        Text("Connexion")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)

                    // Navigation vers inscription
                    NavigationLink {
                        RegisterView()
                    } label: {
                        Text("Créer un compte")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.horizontal, 30)
                .padding(.top, 30)
                
                Spacer()
                Spacer()
            }
        }
    }
}
