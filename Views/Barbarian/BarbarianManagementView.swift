//
//  BarbarianManagementView.swift
//  barbarian_game
//
//  Created by tplocal on 03/12/2025.
//

import SwiftUI

struct BarbarianManagementView: View {
    @EnvironmentObject var vm: BarbarianViewModel

    var body: some View {
        Group {
            if vm.isLoading {
                ProgressView("Chargement...")
            } else if let barbarian = vm.barbarian {
                BarbarianDetailView(barbarian: barbarian)
            } else {
                CreateBarbarianView()
            }
        }
        .task {
            await vm.loadBarbarian()
        }
        .navigationTitle("Barbare")
    }
}
