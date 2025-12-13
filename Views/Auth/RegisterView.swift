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
        VStack(spacing: 0) {
            Spacer()
            
            // Titre
            Text("Créer un compte")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 50)
            
            // Formulaire
            VStack(spacing: 15) {
                TextField("Username", text: $vm.username)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)

                SecureField("Password", text: $vm.password)
                    .textFieldStyle(.roundedBorder)

                if !vm.errorMessage.isEmpty {
                    Text(vm.errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.horizontal, 30)
            
            // Bouton
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
        .alert("Inscription réussie", isPresented: $showSuccessAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Vous pouvez maintenant vous connecter.")
        }
    }
}
