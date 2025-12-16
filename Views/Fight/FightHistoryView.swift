//
//  FightHistoryView.swift
//  barbarian_game
//
//  Created by tplocal on 12/12/2025.
//

import SwiftUI

struct FightHistoryView: View {
    @StateObject var vm = FightHistoryViewModel()
    @EnvironmentObject var barbarianVm: BarbarianViewModel
    
    // ID du barbare connecté
    var myId: Int {
        barbarianVm.barbarian?.id ?? 0
    }

    var body: some View {
        // Scroll principal de l’écran
        ScrollView {
            // Colonne des combats
            VStack(spacing: 16) {
                
                // Indicateur de chargement
                if vm.isLoading {
                    ProgressView("Chargement...")
                        .padding()
                
                // Message si aucun combat
                } else if vm.history.isEmpty {
                    Text("Aucun combat pour le moment")
                        .foregroundColor(.gray)
                        .padding(.top, 100)
                
                // Liste des combats
                } else {
                    ForEach(vm.history) { entry in
                        // Ligne d’un combat
                        FightHistoryRow(entry: entry, myId: myId)
                            .environmentObject(barbarianVm)
                    }
                }
            }
            .padding()
        }
        // Titre de la navigation
        .navigationTitle("⚔️ Historique")
        .navigationBarTitleDisplayMode(.inline)
        
        // Chargement initial
        .task {
            await vm.loadHistory()
        }
    }
}


struct FightHistoryRow: View {
    let entry: FightHistoryEntry
    let myId: Int
    @EnvironmentObject var vm: BarbarianViewModel
    
    // Résultat du combat
    var isVictory: Bool {
        entry.winner_id == myId
    }
    
    // Avatar de l’adversaire
    var opponentAvatarId: Int {
        if entry.attacker_id == myId {
            return entry.defenderAvatarId ?? 1
        } else {
            return entry.attackerAvatarId ?? 1
        }
    }
    // Description textuelle du combat/
    var description: String {
        if entry.attacker_id == myId {
            return "Vous avez attaqué \(entry.defenderName ?? "ID: \(entry.defender_id)")"
        } else {
            return "\(entry.attackerName ?? "ID: \(entry.attacker_id)") vous a attaqué"
        }
    }
    // EXP gagnée par moi
    var myExp: Int {
        entry.attacker_id == myId ? entry.exp_attacker : entry.exp_defender
    }
    
    var body: some View {
        // Ligne horizontale du combat
        HStack(spacing: 16) {
            // Avatar de l'adversaire
            AsyncImage(url: vm.avatarURL(avatarID: opponentAvatarId)) { phase in
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
            
            // Infos du combat
            VStack(alignment: .leading, spacing: 4) {
                Text("Combat #\(entry.id)")
                    .font(.headline)
                // Description attaque/défense
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(entry.attacker_id == myId ? .blue : .orange)
                // Résultat et EXP
                HStack(spacing: 12) {
                    Label(isVictory ? "Victoire" : "Défaite",
                          systemImage: isVictory ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(isVictory ? .green : .red)
                    
                    Label("+\(myExp) EXP", systemImage: "bolt.fill")
                        .foregroundColor(.yellow)
                }
                .font(.subheadline)
                // Date du combat
                Text(formatDate(entry.created_at))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(14)
        .shadow(radius: 2)
    }
    // Formatage de la date
    private func formatDate(_ dateString: String) -> String {
        let components = dateString.split(separator: " ")
        if components.count >= 2 {
            return "\(components[0]) \(components[1].prefix(5))"
        }
        return dateString
    }
}
