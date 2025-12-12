//
//  FightHistoryView.swift
//  barbarian_game
//
//  Created by tplocal on 12/12/2025.
//

import SwiftUI

struct FightHistoryView: View {
    @StateObject var vm = FightHistoryViewModel()
    @State private var showNotification = false
    
    var body: some View {
        ZStack {
            // Background
            Color.gray.opacity(0.05)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 15) {
                    if vm.history.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "list.bullet.rectangle")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                            Text("Aucun combat pour le moment")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 100)
                    } else {
                        ForEach(vm.history) { entry in
                            FightHistoryCard(entry: entry)
                        }
                    }
                }
                .padding()
            }
            
            // Notification en haut
            if showNotification, let newFight = vm.newFightNotification {
                VStack {
                    HStack {
                        Image(systemName: "swords")
                            .foregroundColor(.white)
                        Text("Nouveau combat ! Gagnant: \(newFight.winner_id)")
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                        Button(action: {
                            withAnimation { showNotification = false }
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [Color.orange, Color.red],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.3), radius: 10, y: 5)
                    .padding()
                    
                    Spacer()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .navigationTitle("Historique")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await vm.loadHistory()
            vm.startMonitoring()
        }
        .onDisappear {
            vm.stopMonitoring()
        }
        .onChange(of: vm.newFightNotification) { _ in
            withAnimation(.spring()) {
                showNotification = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.spring()) {
                    showNotification = false
                }
            }
        }
    }
}

struct FightHistoryCard: View {
    let entry: FightHistoryEntry
    
    var isVictory: Bool {
        // Vous devrez adapter selon votre logique pour savoir qui est le joueur
        true
    }
    
    var body: some View {
        VStack(spacing: 12) {
            // Header avec date et résultat
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "calendar")
                        .foregroundColor(.gray)
                        .font(.caption)
                    Text(formatDate(entry.created_at))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text("Combat #\(entry.id)")
                    .font(.caption)
                    .foregroundColor(.blue)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
            }
            
            Divider()
            
            // Combattants
            HStack(spacing: 20) {
                // Attaquant
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(entry.winner_id == entry.attacker_id ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "figure.martial.arts")
                            .font(.title2)
                            .foregroundColor(entry.winner_id == entry.attacker_id ? .green : .red)
                    }
                    
                    Text("Attaquant")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text("ID: \(entry.attacker_id)")
                        .font(.caption)
                        .bold()
                    
                    if entry.winner_id == entry.attacker_id {
                        Text("🏆 Victoire")
                            .font(.caption2)
                            .foregroundColor(.green)
                            .bold()
                    }
                }
                .frame(maxWidth: .infinity)
                
                // VS
                VStack {
                    Text("VS")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.orange)
                    
                    if let lastRound = entry.log.rounds.last {
                        Text("\(lastRound.round) rounds")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
                
                // Défenseur
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(entry.winner_id == entry.defender_id ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "shield.fill")
                            .font(.title2)
                            .foregroundColor(entry.winner_id == entry.defender_id ? .green : .red)
                    }
                    
                    Text("Défenseur")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text("ID: \(entry.defender_id)")
                        .font(.caption)
                        .bold()
                    
                    if entry.winner_id == entry.defender_id {
                        Text("🏆 Victoire")
                            .font(.caption2)
                            .foregroundColor(.green)
                            .bold()
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.vertical, 8)
            
            Divider()
            
            // Stats du combat
            HStack(spacing: 20) {
                StatBadge(
                    icon: "star.fill",
                    label: "EXP Attaquant",
                    value: "+\(entry.exp_attacker)",
                    color: .yellow
                )
                
                StatBadge(
                    icon: "star.fill",
                    label: "EXP Défenseur",
                    value: "+\(entry.exp_defender)",
                    color: .yellow
                )
            }
            
            // Dernier round (optionnel, peut être caché dans un disclosure)
            if let lastRound = entry.log.rounds.last {
                DisclosureGroup {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Acteur:")
                                .foregroundColor(.secondary)
                            Text("\(lastRound.actor)")
                                .bold()
                            Spacer()
                            Text("Cible:")
                                .foregroundColor(.secondary)
                            Text("\(lastRound.target)")
                                .bold()
                        }
                        .font(.caption)
                        
                        HStack {
                            if lastRound.hit {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("Touché - \(lastRound.damage) dégâts")
                                    .foregroundColor(.green)
                            } else {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                                Text("Raté")
                                    .foregroundColor(.red)
                            }
                            Spacer()
                            Text("PV: \(lastRound.hp_target_after)")
                                .foregroundColor(.blue)
                        }
                        .font(.caption)
                    }
                    .padding(8)
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(8)
                } label: {
                    HStack {
                        Image(systemName: "info.circle")
                            .foregroundColor(.blue)
                        Text("Dernier round")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    func formatDate(_ dateString: String) -> String {
        // Format simplifié, vous pouvez utiliser DateFormatter pour plus de contrôle
        let components = dateString.split(separator: " ")
        if components.count >= 2 {
            return "\(components[0]) à \(components[1].prefix(5))"
        }
        return dateString
    }
}

struct StatBadge: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption2)
                Text(value)
                    .font(.caption)
                    .bold()
            }
            .foregroundColor(color)
            
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}
