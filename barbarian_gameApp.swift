//
//  barbarian_gameApp.swift
//  barbarian_game
//
//  Created by tplocal on 02/12/2025.
//

import SwiftUI

@main
struct barbarian_gameApp: App {
    @StateObject var authVm = AuthViewModel()
    @StateObject var barbarianVm = BarbarianViewModel()
    @StateObject var fightVm = FightViewModel()
    @StateObject var historyVm = FightHistoryViewModel()
    // mettre les @StateObject dans l'environement pour les partager à tous le monde
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authVm)
                .environmentObject(barbarianVm)
                .environmentObject(fightVm)
                .environmentObject(historyVm)
            
        }
    }
}

