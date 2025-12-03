//
//  barbarian_gameApp.swift
//  barbarian_game
//
//  Created by tplocal on 02/12/2025.
//

import SwiftUI

@main
struct barbarian_gameApp: App {
    @StateObject var vm = BarbarianViewModel()

    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(vm)   // ⬅️ injection globale ici
        }
    }
}
