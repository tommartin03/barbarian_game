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
        //navigation principale
        NavigationStack {
            
            VStack(spacing: 10) {
                
                //affichage du barbare connecté
                if let bar = vm.barbarian {
                    
                    //avatar du barbare
                    AsyncImage(url: vm.avatarURL(avatarID: bar.avatar_id)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable() //doit etre redimentionnée
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle()) //on affiche dans un cercle
                        default:
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    //nom et progression
                    VStack(spacing: 2) {
                        Text(bar.name)
                            .font(.title2)
                            .bold()

                        //LOVE et EXP
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
                    
                    //points de compétences disponibles
                    if bar.skill_points > 0 {
                        Text("Points disponibles: \(bar.skill_points)")
                            .font(.subheadline)
                            .foregroundColor(.green)
                    }

                    //liste des statistiques
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

                // Bloc des actions principales
                VStack(spacing: 10) {
                    
                    //bouton combat
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

                    //accès historique combats
                    NavigationLink {
                        FightHistoryView()
                            .environmentObject(vm)
                    } label: {
                        Text("Historique")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)

                    //accès classement global
                    NavigationLink {
                        LeaderboardView()
                            .environmentObject(vm)
                    } label: {
                        Text("Classement")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    
                    //suppression du barbare
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

                    //déconnexion utilisateur
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
            
            //chargement initial des données
            .task {
                await vm.loadAvatars()
                await vm.loadBarbarian()
                await fightHistoryVm.loadHistory()
            }
            
            //démarrage du polling historique
            .onAppear {
                fightHistoryVm.startMonitoring()
            }
            .onDisappear {
                fightHistoryVm.stopMonitoring()
            }
            
            //alerte nouveau combat
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
            
            //navigation vers combat
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

//vue ligne statistique réutilisable
struct StatRowView: View {
    let statName: String
    let value: Int
    let canAdd: Bool
    let addAction: () -> Void

    var body: some View {
        //ligne statistique
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
