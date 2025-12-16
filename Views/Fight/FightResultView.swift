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
    
    // Vérifie si victoire
    var isVictory: Bool {
        guard let myId = vm.barbarian?.id else { return false }
        return fightResponse.winner_id == myId
    }
    
    var body: some View {
        // Navigation interne à la sheet
        NavigationStack {
            
            // Conteneur vertical principal
            VStack(spacing: 30) {
                Spacer()
                
                // Icône victoire / défaite
                Image(systemName: isVictory ? "trophy.fill" : "xmark.shield.fill")
                    .font(.system(size: 80))
                    .foregroundColor(isVictory ? .yellow : .red)
                
                // Texte du résultat
                Text(isVictory ? "VICTOIRE !" : "DÉFAITE")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundColor(isVictory ? .green : .red)
                
                // Séparateur visuel
                Divider()
                    .padding(.horizontal, 40)
                
                // Bloc informations adversaire
                VStack(spacing: 10) {
                    
                    // Titre adversaire
                    Text("Adversaire")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    // Avatar adversaire
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
                    
                    // Nom adversaire
                    Text(fightResponse.opponent.name)
                        .font(.title2)
                        .bold()
                }
                
                // Bloc expérience gagnée
                if isVictory {
                    VStack(spacing: 5) {
                        
                        // Label EXP
                        Text("Expérience gagnée")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        // Valeur EXP
                        Text("+\(fightResponse.exp_gain) EXP")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.orange)
                    }
                    .padding()
                    // Carte EXP stylisée
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.orange.opacity(0.1))
                    )
                }
                
                Spacer()
                
                // Bouton retour menu
                Button(action: {
                    dismiss() // Ferme la sheet
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        onDismissAll() // Ferme vue combat
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
            // Titre de navigation
            .navigationTitle("Résultat")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
