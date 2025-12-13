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
    
    var myBarbarianId: Int {
        vm.barbarian?.id ?? 0
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // En-tête avec les combattants
            HStack(spacing: 30) {
                if let myBar = vm.barbarian {
                    FighterAvatar(avatarId: myBar.avatar_id, name: myBar.name, hp: myBar.hp_max, hpColor: .green, vm: vm)
                }
                
                Text("VS")
                    .font(.title2)
                    .foregroundColor(.orange)
                    .bold()
                
                FighterAvatar(avatarId: fightResponse.opponent.avatar_id, name: fightResponse.opponent.name, hp: fightResponse.opponent.hp_max, hpColor: .red, vm: vm)
            }
            .padding(.vertical, 20)
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .background(Color(.secondarySystemBackground))
            
            // Liste des rounds
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(fightResponse.log.rounds) { round in
                        RoundRow(round: round, myBarbarianId: myBarbarianId, opponentName: fightResponse.opponent.name)
                    }
                }
                .padding()
            }
            
            // Bouton résultats
            NavigationLink(destination: FightResultView(fightResponse: fightResponse)) {
                Text("Voir les résultats")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .navigationTitle("⚔️ Combat")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RoundRow: View {
    let round: FightRound
    let myBarbarianId: Int
    let opponentName: String
    
    var isMyAttack: Bool {
        round.actor == myBarbarianId
    }
    
    var hpColor: Color {
        // Si c'est mon attaque, la cible est l'adversaire (rouge)
        // Sinon, la cible c'est moi (vert)
        isMyAttack ? .red : .green
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Numéro du round
            Text("\(round.round)")
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(Circle().fill(Color.blue))
            
            // Description
            VStack(alignment: .leading, spacing: 4) {
                Text(isMyAttack ? "Vous attaquez" : "\(opponentName) attaque")
                    .font(.subheadline)
                    .foregroundColor(isMyAttack ? .green : .red)
                
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
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(round.hp_target_after)")
                    .font(.headline)
                    .foregroundColor(hpColor)
                Text("HP")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
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
        VStack(spacing: 8) {
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
            Text(name)
                .font(.caption)
                .bold()
            Text("\(hp) HP")
                .font(.caption2)
                .foregroundColor(hpColor)
        }
    }
}
