//
//  FightResultView.swift
//  barbarian_game
//
//  Created by tplocal on 11/12/2025.
//

import SwiftUI

struct FightResultView: View {
    let fightResponse: FightResponse
    let onDismissAll: () -> Void
    @EnvironmentObject var vm: BarbarianViewModel
    @Environment(\.dismiss) private var dismiss
    
    var isVictory: Bool {
        guard let myId = vm.barbarian?.id else { return false }
        return fightResponse.winner_id == myId
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Spacer()
                
                // Icône de résultat
                Image(systemName: isVictory ? "trophy.fill" : "xmark.shield.fill")
                    .font(.system(size: 80))
                    .foregroundColor(isVictory ? .yellow : .red)
                
                // Résultat
                Text(isVictory ? "VICTOIRE !" : "DÉFAITE")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundColor(isVictory ? .green : .red)
                
                Divider()
                    .padding(.horizontal, 40)
                
                // Infos adversaire
                VStack(spacing: 10) {
                    Text("Adversaire")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    AsyncImage(url: vm.avatarURL(avatarID: fightResponse.opponent.avatar_id)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                        default:
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Text(fightResponse.opponent.name)
                        .font(.title2)
                        .bold()
                }
                
                // EXP gagnée
                if isVictory {
                    VStack(spacing: 5) {
                        Text("Expérience gagnée")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text("+\(fightResponse.exp_gain) EXP")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.orange)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.orange.opacity(0.1))
                    )
                }
                
                Spacer()
                
                // Bouton retour
                Button(action: {
                    dismiss() // Ferme la sheet
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        onDismissAll() // Puis ferme FightDetailView
                    }
                }) {
                    Text("Retour au menu")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 30)
            }
            .navigationTitle("Résultat")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
