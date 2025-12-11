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
                    Task { await authVm.login() }
                }
                .buttonStyle(.borderedProminent) // bouton actif

                NavigationLink("Register") {
                    RegisterView()
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
    }
}
