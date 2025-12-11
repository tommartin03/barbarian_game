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
        VStack(spacing: 30) {
            Spacer()
            
            // Résultat
            Text(isVictory ? "VICTOIRE" : "DÉFAITE")
                .font(.largeTitle)
                .bold()
                .foregroundColor(isVictory ? .green : .red)
            
            // Les deux barbares côte à côte
            HStack(spacing: 40) {
                // Mon barbare
                VStack(spacing: 10) {
                    if let myBar = vm.barbarian {
                        AsyncImage(url: myBar.avatarURL) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(isVictory ? Color.green : Color.red, lineWidth: 3)
                        )
                        
                        Text(myBar.name)
                            .font(.headline)
                        
                        if isVictory {
                            Image(systemName: "crown.fill")
                                .foregroundColor(.yellow)
                        }
                    }
                }
                
                Text("VS")
                    .font(.title)
                    .foregroundColor(.gray)
                
                // Adversaire
                VStack(spacing: 10) {
                    AsyncImage(url: fightResponse.opponent.avatarURL) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(!isVictory ? Color.green : Color.red, lineWidth: 3)
                    )
                    
                    Text(fightResponse.opponent.name)
                        .font(.headline)
                    
                    if !isVictory {
                        Image(systemName: "crown.fill")
                            .foregroundColor(.yellow)
                    }
                }
            }
            
            // EXP gagnée
            if isVictory {
                VStack(spacing: 5) {
                    Text("Expérience")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Text("+\(fightResponse.exp_gain) EXP")
                        .font(.title)
                        .bold()
                        .foregroundColor(.orange)
                }
            }
            
            Spacer()
            
            // Bouton retour
            Button("Retour au menu") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 30)
            .padding(.bottom, 40)
        }
        .navigationBarBackButtonHidden(true)
    }
}
