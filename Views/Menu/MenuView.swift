//
//  MenuView.swift
//  barbarian_game
//
//  Created by tplocal on 03/12/2025.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var vm: BarbarianViewModel
    @EnvironmentObject var authVm: AuthViewModel
    @EnvironmentObject var fightVm: FightViewModel
    @EnvironmentObject var fightHistoryVm: FightHistoryViewModel

    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var navigateToFight = false

    var body: some View {
        // Navigation principale
        NavigationStack {
            
            // Conteneur principal vertical
            VStack(spacing: 10) {
                
                // Affichage du barbare connecté
                if let bar = vm.barbarian {
                    
                    // Avatar du barbare
                    AsyncImage(url: vm.avatarURL(avatarID: bar.avatar_id)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        default:
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // Nom et progression
                    VStack(spacing: 2) {
                        Text(bar.name)
                            .font(.title2)
                            .bold()

                        // LOVE et EXP
                        HStack(spacing: 10) {
                            Text("🔥 LOVE \(bar.love)")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.red)

                            Text("EXP \(bar.exp)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // Points de compétences disponibles
                    if bar.skill_points > 0 {
                        Text("Points disponibles: \(bar.skill_points)")
                            .font(.subheadline)
                            .foregroundColor(.green)
                    }

                    // Liste des statistiques
                    VStack(spacing: 8) {
                        StatRowView(statName: "Attaque", value: bar.attack, canAdd: bar.skill_points > 0) {
                            vm.addPoint(to: "attack")
                        }
                        StatRowView(statName: "Défense", value: bar.defense, canAdd: bar.skill_points > 0) {
                            vm.addPoint(to: "defense")
                        }
                        StatRowView(statName: "Précision", value: bar.accuracy, canAdd: bar.skill_points > 0) {
                            vm.addPoint(to: "accuracy")
                        }
                        StatRowView(statName: "Esquive", value: bar.evasion, canAdd: bar.skill_points > 0) {
                            vm.addPoint(to: "evasion")
                        }
                        StatRowView(statName: "PV max", value: bar.hp_max, canAdd: false, addAction: {})
                    }
                    .padding()
                }

                // Espacement visuel
                Spacer().frame(height: 10)

                // Bloc des actions principales
                VStack(spacing: 10) {
                    
                    // Bouton combat
                    Button {
                        Task {
                            let success = await fightVm.startFight()
                            if success {
                                navigateToFight = true
                                await vm.loadBarbarian()
                            } else {
                                alertMessage = fightVm.errorMessage
                                showAlert = true
                            }
                        }
                    } label: {
                        if fightVm.isLoading {
                            HStack {
                                ProgressView()
                                Text("Recherche...")
                            }
                            .frame(maxWidth: .infinity)
                        } else {
                            Text("Combat")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(fightVm.isLoading)

                    // Accès historique combats
                    NavigationLink {
                        FightHistoryView()
                            .environmentObject(vm)
                    } label: {
                        Text("Historique")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)

                    // Accès classement global
                    NavigationLink {
                        LeaderboardView()
                            .environmentObject(vm)
                    } label: {
                        Text("Classement")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    
                    // Suppression du barbare
                    Button {
                        Task {
                            await vm.resetBarbarian()
                        }
                    } label: {
                        Text("Supprimer le barbare")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)

                    // Déconnexion utilisateur
                    Button {
                        Task {
                            await authVm.logout()
                        }
                    } label: {
                        Text("Déconnexion")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                }
                .padding()
            }
            .padding(.top, 10)
            
            // Chargement initial des données
            .task {
                await vm.loadAvatars()
                await vm.loadBarbarian()
                await fightHistoryVm.loadHistory()
            }
            
            // Démarrage du polling historique
            .onAppear {
                fightHistoryVm.startMonitoring()
            }
            .onDisappear {
                fightHistoryVm.stopMonitoring()
            }
            
            // Alerte nouveau combat
            .alert(
                "Nouveau combat",
                isPresented: Binding(
                    get: { fightHistoryVm.newFightNotification != nil },
                    set: { _ in fightHistoryVm.newFightNotification = nil }
                )
            ) {
                Button("OK", role: .cancel) {
                    fightHistoryVm.newFightNotification = nil
                }
            } message: {
                Text("Un nouveau combat est disponible dans l'historique.")
            }
            
            // Navigation vers combat
            .navigationDestination(isPresented: $navigateToFight) {
                if let fight = fightVm.currentFight {
                    FightDetailView(fightResponse: fight)
                        .environmentObject(vm)
                        .onDisappear {
                            fightVm.resetFight()
                        }
                }
            }
        }
    }
}

// Vue ligne statistique réutilisable
struct StatRowView: View {
    let statName: String
    let value: Int
    let canAdd: Bool
    let addAction: () -> Void

    var body: some View {
        // Ligne statistique unique
        HStack {
            Text(statName)
            Spacer()
            Text("\(value)")
                .bold()
            if canAdd {
                Button(action: addAction) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}
