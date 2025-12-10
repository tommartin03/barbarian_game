//
//  MenuView.swift
//  barbarian_game
//
//  Created by tplocal on 03/12/2025.
//
import SwiftUI

struct MenuView: View {
    @EnvironmentObject var vm: BarbarianViewModel

    var body: some View {
        VStack(spacing: 20) {
            if let bar = vm.barbarian {
                // Avatar
                AsyncImage(url: bar.avatarURL) { phase in
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
                    case .failure:
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 180, height: 180)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                    @unknown default:
                        EmptyView()
                    }
                }

                // Nom et exp
                VStack(spacing: 5) {
                    Text(bar.name)
                        .font(.largeTitle)
                        .bold()
                    Text("Exp: \(bar.exp)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
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
                    StatRowView(statName: "Amour", value: bar.love, canAdd: false, addAction: {})
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 15).fill(Color.gray.opacity(0.1)))
                .padding(.horizontal)
            }

            Spacer()

            // Boutons plus petits et simples
            HStack(spacing: 15) {
                Button("Combat") { /* Navigation vers combat */ }
                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity)
                Button("Historique") { /* Navigation vers historique */ }
                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity)
                Button("Déconnexion") {
                    vm.logout()
                    // Retour à LoginView
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
