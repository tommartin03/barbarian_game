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

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if let bar = vm.barbarian {
                    // Avatar avec debug
                    AsyncImage(url: vm.avatarURL(for: bar)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 180, height: 180)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 180, height: 180)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                        case .failure(let error):
                            VStack {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 180, height: 180)
                                    .clipShape(Circle())
                                    .shadow(radius: 10)
                                Text("Erreur: avatar_id = \(bar.avatar_id)")
                                    .font(.caption)
                                    .foregroundColor(.red)
                                Text("URL: \(vm.avatarURL(for: bar).absoluteString)")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                            .onAppear {
                                print("❌ Échec du chargement de l'avatar")
                                print("URL tentée: \(vm.avatarURL(for: bar).absoluteString)")
                                print("Avatar ID: \(bar.avatar_id)")
                                print("Erreur: \(error)")
                            }
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .onAppear {
                        print("🎭 Tentative de chargement de l'avatar")
                        print("Avatar ID du barbare: \(bar.avatar_id)")
                        print("URL tentée: \(vm.avatarURL(for: bar).absoluteString)")
                    }

                    // Nom et exp
                    VStack(spacing: 5) {
                        Text(bar.name)
                            .font(.largeTitle)
                            .bold()
                        Text("Exp: \(bar.exp)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        // Debug info
                        Text("Avatar ID: \(bar.avatar_id)")
                            .font(.caption2)
                            .foregroundColor(.blue)
                    }

                    // Points de compétence disponibles
                    if bar.skill_points > 0 {
                        Text("Points de compétence disponibles: \(bar.skill_points)")
                            .font(.headline)
                            .foregroundColor(.green)
                            .padding(.vertical, 5)
                    }

                    // Stats principales avec boutons + interactifs
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

                        // Autres stats non modifiables
                        StatRowView(statName: "PV max", value: bar.hp_max, canAdd: false, addAction: {})
                        StatRowView(statName: "LOVE", value: bar.love, canAdd: false, addAction: {})
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.gray.opacity(0.1)))
                    .padding(.horizontal)
                }

                Spacer()

                // Boutons plus petits et simples
                HStack(spacing: 15) {
                    Button("Combat") {
                        Task {
                            do {
                                let repo = FightRepository()
                                let response = try await repo.startFight()
                                
                                // Stocker la réponse et afficher la vue de déroulé
                                fightResponse = response
                                showFightResult = true
                                
                                // Recharger le barbare après
                                await vm.loadBarbarian()

                            } catch {
                                print("❌ Erreur: \(error)")
                                alertMessage = "Erreur lors du combat: \(error.localizedDescription)"
                                showAlert = true
                            }
                        }
                    }
                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity)
                    
                    Button("Historique") {
                        showHistory = true
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
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .padding(.top, 20)
            .task {
                await vm.loadAvatars() // charger la liste des avatars
                await vm.loadBarbarian() // charger le barbare
            }
            .alert("Combat", isPresented: $showAlert) {
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
                .font(.headline)
            Spacer()
            Text("\(value)")
                .font(.title3)
                .bold()
            if canAdd {
                Button(action: addAction) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                        .font(.title2)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
        )
    }
}
