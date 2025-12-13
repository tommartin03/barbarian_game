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
        NavigationStack {
            VStack(spacing: 0) {
                Spacer()
                
                // Titre
                Text("Barbarian Game")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 50)
                
                // Formulaire
                VStack(spacing: 15) {
                    TextField("Username", text: $authVm.username)
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                        .autocorrectionDisabled(true)

                    SecureField("Password", text: $authVm.password)
                        .textFieldStyle(.roundedBorder)

                    if !authVm.errorMessage.isEmpty {
                        Text(authVm.errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.horizontal, 30)
                
                // Boutons
                VStack(spacing: 12) {
                    Button {
                        Task { await authVm.login() }
                    } label: {
                        Text("Connexion")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)

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
