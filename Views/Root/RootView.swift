//
//  RootView.swift
//  barbarian_game
//
//  Created by tplocal on 11/12/2025.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var authVm: AuthViewModel

    var body: some View {
        if authVm.isAuthenticated {
            MenuView()
        } else {
            LoginView()
        }
    }
}
