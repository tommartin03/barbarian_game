//
//  LoginView.swift
//  barbarian_game
//
//  Created by tplocal on 02/12/2025.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var vm = AuthViewModel()
    @State private var navigateToBarbarian = false

    var body: some View {
        NavigationStack {
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

                Button("Login") {
                    Task {
                        await vm.login()
                        if vm.isAuthenticated {
                            navigateToBarbarian = true
                        }
                    }
                }

                NavigationLink("Register", destination: RegisterView())

                NavigationLink(
                    destination: BarbarianManagementView(),
                    isActive: $navigateToBarbarian,
                    label: { EmptyView() }
                )
            }
            .padding()
        }
    }
}
