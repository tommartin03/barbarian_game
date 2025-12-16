//
//  RegisterView.swift
//  barbarian_game
//
//  Created by tplocal on 02/12/2025.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var vm = AuthViewModel()
    @State private var showSuccessAlert = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        // Conteneur principal
        VStack(spacing: 0) {
            Spacer()
            
            // Titre inscription
            Text("Créer un compte")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 50)
            
            // Formulaire utilisateur
            VStack(spacing: 15) {
                
                // Champ nom utilisateur
                TextField("Username", text: $vm.username)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)

                // Champ mot de passe
                SecureField("Password", text: $vm.password)
                    .textFieldStyle(.roundedBorder)

                // Message d’erreur API
                if !vm.errorMessage.isEmpty {
                    Text(vm.errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.horizontal, 30)
            
            // Bouton inscription
            Button {
                Task {
                    await vm.register()
                    if vm.isRegistered {
                        showSuccessAlert = true
                    }
                }
            } label: {
                Text("S'inscrire")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 30)
            .padding(.top, 30)
            
            Spacer()
            Spacer()
        }
        
        // Alerte succès inscription
        .alert("Inscription réussie", isPresented: $showSuccessAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Vous pouvez maintenant vous connecter.")
        }
    }
}
