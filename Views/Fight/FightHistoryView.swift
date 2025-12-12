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
    
    var myId: Int {
        barbarianVm.barbarian?.id ?? 0
    }
    
    var body: some View {
        VStack {
            if vm.history.isEmpty {
                Text("Aucun combat pour le moment")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(vm.history) { entry in
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Combat #\(entry.id)")
                                .font(.headline)
                            Spacer()
                            Text(entry.created_at)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        // Rôle dans le combat
                        if entry.attacker_id == myId {
                            Text("Vous avez attaqué")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        } else if entry.defender_id == myId {
                            Text("Vous avez défendu")
                                .font(.subheadline)
                                .foregroundColor(.orange)
                        }
                        
                        // Résultat
                        HStack {
                            if entry.winner_id == myId {
                                Text("🏆 Victoire")
                                    .foregroundColor(.green)
                                    .bold()
                            } else {
                                Text("💀 Défaite")
                                    .foregroundColor(.red)
                                    .bold()
                            }
                            
                            Spacer()
                            
                            // EXP gagnée par moi
                            let myExp = entry.attacker_id == myId ? entry.exp_attacker : entry.exp_defender
                            Text("+\(myExp) EXP")
                                .foregroundColor(.orange)
                                .bold()
                        }
                        .font(.subheadline)
                    }
                    .padding(.vertical, 5)
                }
            }
        }
        .navigationTitle("Historique")
        .task {
            await vm.loadHistory()
        }
    }
}
