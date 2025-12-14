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
        NavigationStack {
            //affichage du barbare
            VStack(spacing: 10) {
                if let bar = vm.barbarian {
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
                    VStack(spacing: 2) {
                        Text(bar.name)
                            .font(.title2)
                            .bold()

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
                    //gestion des compétences
                    if bar.skill_points > 0 {
                        Text("Points disponibles: \(bar.skill_points)")
                            .font(.subheadline)
                            .foregroundColor(.green)
                    }

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

                Spacer().frame(height: 10)

                //gestion des boutons
                VStack(spacing: 10) {
                    // Combat
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

                    // Historique
                    NavigationLink {
                        FightHistoryView()
                            .environmentObject(vm)
                    } label: {
                        Text("Historique")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)

                    // Classement
                    NavigationLink {
                        LeaderboardView()
                            .environmentObject(vm)
                    } label: {
                        Text("Classement")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)

                    // Déconnexion
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
            .task {
                await vm.loadAvatars()
                await vm.loadBarbarian()
                await fightHistoryVm.loadHistory()
            }
            
            //démarage du pooling pour veirfier si il y a un nouveau combat dans l'historique
            .onAppear {
                fightHistoryVm.startMonitoring()
            }
            .onDisappear {
                fightHistoryVm.stopMonitoring()
            }
            
            //alerte nouveaux combat
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
            //gestion de la navigation pour les combats
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

// Vue réutilisable pour chaque stat
struct StatRowView: View {
    let statName: String
    let value: Int
    let canAdd: Bool
    let addAction: () -> Void

    var body: some View {
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
