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
        //bavigation principale
        NavigationStack {
            
            //conteneur principal
            VStack(spacing: 0) {
                Spacer()
                
                //titre du jeu
                Text("Barbarian Game")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 50)
                
                //formulaire de connexion
                VStack(spacing: 15) {
                    
                    //champ nom utilisateur
                    TextField("Username", text: $authVm.username)
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                        .autocorrectionDisabled(true)

                    //champ mot de passe
                    SecureField("Password", text: $authVm.password)
                        .textFieldStyle(.roundedBorder)

                    //message erreur authentification
                    if !authVm.errorMessage.isEmpty {
                        Text(authVm.errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.horizontal, 30)
                
                //boutons actions utilisateur
                VStack(spacing: 12) {
                    
                    //bouton connexion API
                    Button {
                        Task { await authVm.login() }
                    } label: {
                        Text("Connexion")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)

                    //navigation vers inscription
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
