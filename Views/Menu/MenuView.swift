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
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var fightResponse: FightResponse? = nil
    @State private var showFightResult = false
    @State private var showHistory = false
    @State private var showLeaderBoard = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if let bar = vm.barbarian {
                    // Avatar
                    AsyncImage(url: vm.avatarURL(avatarID: bar.avatar_id)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                        default:
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 120, height: 120)
                                .foregroundColor(.gray)
                        }
                    }

                    // Nom et exp
                    Text(bar.name)
                        .font(.title)
                        .bold()
                    
                    Text("Exp: \(bar.exp)")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    // Points de compétence disponibles
                    if bar.skill_points > 0 {
                        Text("Points disponibles: \(bar.skill_points)")
                            .font(.headline)
                            .foregroundColor(.green)
                    }

                    // Stats
                    VStack(spacing: 10) {
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

                Spacer()

                // Boutons
                HStack(spacing: 15) {
                    Button("Combat") {
                        Task {
                            do {
                                let repo = FightRepository()
                                let response = try await repo.startFight()
                                
                                fightResponse = response
                                showFightResult = true
                                
                                await vm.loadBarbarian()

                            } catch {
                                alertMessage = "Erreur lors du combat"
                                showAlert = true
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)
                    
                    Button("Historique") {
                        showHistory = true
                    }
                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity)
                    
                    Button("Leaderboard") {
                            showLeaderBoard = true
                        }
                        .buttonStyle(.bordered)
                        .frame(maxWidth: .infinity)
                    
                    Button("Déconnexion") {
                        Task {
                            await authVm.logout()
                        }
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                    .frame(maxWidth: .infinity)
                }
                .padding()
            }
            .padding(.top, 20)
            .task {
                await vm.loadAvatars()
                await vm.loadBarbarian()
            }
            .alert("Erreur", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            .navigationDestination(isPresented: $showFightResult) {
                if let response = fightResponse {
                    FightDetailView(fightResponse: response)
                        .environmentObject(vm)
                }
            }
            .navigationDestination(isPresented: $showLeaderBoard) {
                LeaderboardView()
                    .environmentObject(vm)
            }
            .navigationDestination(isPresented: $showHistory) {
                FightHistoryView()
                    .environmentObject(vm)
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
