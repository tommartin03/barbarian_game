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
                AsyncImage(url: vm.avatarURL(for: bar)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable().scaledToFill()
                    case .failure:
                        Image(systemName: "person.crop.circle.fill") // fallback
                            .resizable()
                            .scaledToFill()
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 120, height: 120)
                .clipShape(Circle())
            }

            Button("Combat") { /* Navigation vers combat */ }
            Button("Historique") { /* Navigation vers historique */ }
            Button("Barbare") { /* Navigation vers stats */ }
            Button("Déconnexion") {
                vm.logout()
                // Retour à LoginView
            }
        }
        .task {
            await vm.loadAvatars() // charger la liste des avatars au lancement
        }
    }
}
