//
//  FightDetailView.swift
//  barbarian_game
//
//  Created by tplocal on 11/12/2025.
//

import SwiftUI

struct FightDetailView: View {
    let fightResponse: FightResponse
    @EnvironmentObject var vm: BarbarianViewModel
    @State private var showResults = false
    @Environment(\.dismiss) private var dismiss
    
    // ID du barbare connecté
    var myBarbarianId: Int {
        vm.barbarian?.id ?? 0
    }
    
    var body: some View {
        // Conteneur principal vertical
        VStack(spacing: 0) {
            
            // En-tête des combattants
            HStack(spacing: 30) {
                
                // Avatar du joueur
                if let myBar = vm.barbarian {
                    FighterAvatar(
                        avatarId: myBar.avatar_id,
                        name: myBar.name,
                        hp: myBar.hp_max,
                        hpColor: .green,
                        vm: vm
                    )
                }
                
                // Texte VS central
                Text("VS")
                    .font(.title2)
                    .foregroundColor(.orange)
                    .bold()
                
                // Avatar de l’adversaire
                FighterAvatar(
                    avatarId: fightResponse.opponent.avatar_id,
                    name: fightResponse.opponent.name,
                    hp: fightResponse.opponent.hp_max,
                    hpColor: .red,
                    vm: vm
                )
            }
            .padding(.vertical, 20)
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            // Fond de l’en-tête
            .background(Color(.secondarySystemBackground))
            
            // Liste scrollable des rounds
            ScrollView {
                // Colonne des rounds
                VStack(spacing: 12) {
                    ForEach(fightResponse.log.rounds) { round in
                        // Ligne d’un round
                        RoundRow(
                            round: round,
                            myBarbarianId: myBarbarianId,
                            opponentName: fightResponse.opponent.name
                        )
                    }
                }
                .padding()
            }
            
            // Bouton d’accès aux résultats
            Button(action: {
                showResults = true
            }) {
                Text("Voir les résultats")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        // Titre de navigation
        .navigationTitle("⚔️ Combat")
        .navigationBarTitleDisplayMode(.inline)
        
        // Fenêtre des résultats
        .sheet(isPresented: $showResults) {
            FightResultView(
                fightResponse: fightResponse,
                onDismissAll: {
                    dismiss()
                }
            )
            .environmentObject(vm)
        }
    }
}


struct RoundRow: View {
    let round: FightRound
    let myBarbarianId: Int
    let opponentName: String
    
    // Indique si j’attaque
    var isMyAttack: Bool {
        round.actor == myBarbarianId
    }
    
    // Couleur des HP affichés
    var hpColor: Color {
        // Rouge si adversaire touché
        // Vert si joueur touché
        isMyAttack ? .red : .green
    }
    
    var body: some View {
        // Ligne horizontale du round
        HStack(spacing: 12) {
            
            // Numéro du round
            Text("\(round.round)")
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(Circle().fill(Color.blue))
            
            // Description de l’action
            VStack(alignment: .leading, spacing: 4) {
                Text(isMyAttack ? "Vous attaquez" : "\(opponentName) attaque")
                    .font(.subheadline)
                    .foregroundColor(isMyAttack ? .green : .red)
                
                // Résultat du coup
                if round.hit {
                    Text("💥 -\(round.damage) HP")
                        .font(.caption)
                        .foregroundColor(.orange)
                        .bold()
                } else {
                    Text("❌ Raté")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            // HP restants de la cible
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(round.hp_target_after)")
                    .font(.headline)
                    .foregroundColor(hpColor)
                Text("HP")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
        // Carte visuelle du round
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}


struct FighterAvatar: View {
    let avatarId: Int
    let name: String
    let hp: Int
    let hpColor: Color
    let vm: BarbarianViewModel
    
    var body: some View {
        // Colonne avatar + infos
        VStack(spacing: 8) {
            
            // Avatar circulaire
            AsyncImage(url: vm.avatarURL(avatarID: avatarId)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                default:
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .foregroundColor(.gray)
                }
            }
            
            // Nom du combattant
            Text(name)
                .font(.caption)
                .bold()
            
            // Points de vie
            Text("\(hp) HP")
                .font(.caption2)
                .foregroundColor(hpColor)
        }
    }
}

