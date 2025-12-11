//
//  FightResultView.swift
//  barbarian_game
//
//  Created by tplocal on 11/12/2025.
//


import SwiftUI

struct FightResultView: View {
    let fightResponse: FightResponse
    @Environment(\.dismiss) private var dismiss
    
    var isVictory: Bool {
        fightResponse.winner_id == fightResponse.log.attacker_id
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Résultat
            Text(isVictory ? "VICTOIRE" : "DÉFAITE")
                .font(.largeTitle)
                .bold()
                .foregroundColor(isVictory ? .green : .red)
            
            // Adversaire
            VStack(spacing: 10) {
                Text("Adversaire")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                AsyncImage(url: fightResponse.opponent.avatarURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                }
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                
                Text(fightResponse.opponent.name)
                    .font(.title2)
                    .bold()
            }
            
            // EXP gagnée
            VStack(spacing: 5) {
                Text("Expérience")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Text("+\(fightResponse.exp_gain) EXP")
                    .font(.title)
                    .bold()
                    .foregroundColor(.orange)
            }
            
            Spacer()
            
            // Bouton retour
            Button("Retour") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .padding(.bottom, 40)
        }
        .navigationBarBackButtonHidden(true)
    }
}
