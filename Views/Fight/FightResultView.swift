//
//  FightResultView.swift
//  barbarian_game
//
//  Created by tplocal on 11/12/2025.
//

import SwiftUI

struct FightResultView: View {
    let fightResponse: FightResponse
    @EnvironmentObject var vm: BarbarianViewModel
    @Environment(\.dismiss) private var dismiss
    
    var isVictory: Bool {
        guard let myId = vm.barbarian?.id else { return false }
        return fightResponse.winner_id == myId
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text(isVictory ? "VICTOIRE !" : "DÉFAITE")
                .font(.largeTitle)
                .foregroundColor(isVictory ? .green : .red)
            
            Text("Adversaire : \(fightResponse.opponent.name)")
                .font(.title2)
            
            Text("EXP gagnée : +\(fightResponse.exp_gain)")
                .font(.title3)
            
            Button("Retour") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 20)
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}
