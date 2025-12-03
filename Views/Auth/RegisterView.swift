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
    @Environment(\.dismiss) var dismiss  // permet de fermer la vue actuelle

    var body: some View {
        VStack(spacing: 20) {
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
                    .multilineTextAlignment(.center)
            }

            Button("Register") {
                Task {
                    await vm.register()
                    if vm.isRegistered {
                        showSuccessAlert = true
                    }
                }
            }
        }
        .padding()
        .alert("Inscription réussie", isPresented: $showSuccessAlert) {
            Button("OK") {
                dismiss()  // ferme RegisterView et revient sur LoginView
            }
        } message: {
            Text("Vous pouvez maintenant vous connecter avec vos identifiants.")
        }
    }
}

