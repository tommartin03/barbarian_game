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

    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                if let bar = vm.barbarian {
                    // Avatar
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

                    // Nom et exp
                    VStack(spacing: 2) {
                        Text(bar.name)
                            .font(.title2)
                            .bold()
                        
                        Text("Exp: \(bar.exp)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    // Points de compétence disponibles
                    if bar.skill_points > 0 {
                        Text("Points disponibles: \(bar.skill_points)")
                            .font(.subheadline)
                            .foregroundColor(.green)
                    }

                    // Stats
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

                Spacer()
                    .frame(height: 10)

                // Boutons en vertical
                VStack(spacing: 10) {
                    Button {
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
                    } label: {
                        Text("Combat")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    
                    NavigationLink {
                        FightHistoryView()
                            .environmentObject(vm)
                    } label: {
                        Text("Historique")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    
                    NavigationLink {
                        LeaderboardView()
                            .environmentObject(vm)
                    } label: {
                        Text("Classement")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    
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
