//
//  LeaderBoardView.swift
//  barbarian_game
//
//  Created by tplocal on 12/12/2025.
//

import SwiftUI

struct LeaderboardView: View {
    @EnvironmentObject var vm: BarbarianViewModel
    @StateObject private var lbVM = LeaderboardViewModel()

    //corps principale de la page
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(lbVM.leaders) { bar in
                    LeaderboardRow(bar: bar)
                        .environmentObject(vm)
                }
            }
            .padding()
        }
        .navigationTitle("🏆 Classement")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            // Chargement immédiat quand on ouvre la vue
            await lbVM.loadLeaderboard()
        }
    }
}

struct LeaderboardRow: View {
    @EnvironmentObject var vm: BarbarianViewModel
    let bar: LeaderboardBarbarian
    
    //corps de l'affichage
    var body: some View {
        
        //Avatar du barbare
        HStack(spacing: 16) {

            AsyncImage(url: vm.avatarURL(avatarID: bar.avatar_id)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                default:
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .foregroundColor(.gray)
                }
            }

            //infos joueur ---
            VStack(alignment: .leading, spacing: 4) {
                Text(bar.name)
                    .font(.headline)

                HStack(spacing: 12) {
                    Label("\(bar.love)", systemImage: "flamme.fill")
                        .foregroundColor(.red)
                    Label("\(bar.exp)", systemImage: "bolt.fill")
                        .foregroundColor(.yellow)
                }
                .font(.subheadline)

                // Stats
                HStack(spacing: 10) {
                    stat("⚔️", bar.attack)
                    stat("🛡️", bar.defense)
                    stat("🎯", bar.accuracy)
                    stat("👟", bar.evasion)
                }
                .font(.caption)
            }

            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(14)
        .shadow(radius: 2)
    }
    
    //affiche le statistique sous une certain forme 
    private func stat(_ emoji: String, _ value: Int) -> some View {
        HStack(spacing: 4) {
            Text(emoji)
            Text("\(value)")
        }
    }
}
