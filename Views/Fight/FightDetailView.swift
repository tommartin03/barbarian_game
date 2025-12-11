//
//  FightDetailView.swift
//  barbarian_game
//
//  Created by tplocal on 11/12/2025.
//

import SwiftUI

struct FightDetailView: View {
    let fightResponse: FightResponse
    @EnvironmentObject var vm: BarbarianViewModel
    @State private var currentRoundIndex = 0
    @State private var isAutoPlaying = false
    @State private var showResults = false
    
    var myBarbarianId: Int {
        vm.barbarian?.id ?? 0
    }
    
    var allRoundsShown: Bool {
        currentRoundIndex >= fightResponse.log.rounds.count
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // En-tête avec les deux barbares
            HStack(spacing: 30) {
                // Mon barbare
                VStack {
                    if let myBar = vm.barbarian {
                        AsyncImage(url: myBar.avatarURL) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        
                        Text(myBar.name)
                            .font(.caption)
                            .bold()
                    }
                }
                
                Text("VS")
                    .font(.title)
                    .foregroundColor(.gray)
                
                // Adversaire
                VStack {
                    AsyncImage(url: fightResponse.opponent.avatarURL) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    
                    Text(fightResponse.opponent.name)
                        .font(.caption)
                        .bold()
                }
            }
            .padding()
            
            // Progression
            if !allRoundsShown {
                Text("Round \(currentRoundIndex) / \(fightResponse.log.rounds.count)")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            
            Divider()
            
            // Liste des rounds affichés jusqu'à maintenant
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(Array(fightResponse.log.rounds.prefix(currentRoundIndex).enumerated()), id: \.element.id) { index, round in
                            RoundRow(
                                round: round,
                                myBarbarianId: myBarbarianId,
                                myBarbarianName: vm.barbarian?.name ?? "Vous",
                                opponentName: fightResponse.opponent.name
                            )
                            .id(round.id)
                        }
                    }
                    .padding()
                }
                .onChange(of: currentRoundIndex) { _, newValue in
                    if newValue > 0, newValue <= fightResponse.log.rounds.count {
                        let round = fightResponse.log.rounds[newValue - 1]
                        withAnimation {
                            proxy.scrollTo(round.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            Spacer()
            
            // Boutons de contrôle
            VStack(spacing: 15) {
                if !allRoundsShown {
                    // Boutons pendant le combat
                    HStack(spacing: 20) {
                        Button(action: {
                            showNextRound()
                        }) {
                            Label("Round suivant", systemImage: "arrow.right.circle.fill")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button(action: {
                            toggleAutoPlay()
                        }) {
                            Label(isAutoPlaying ? "Pause" : "Auto", systemImage: isAutoPlaying ? "pause.fill" : "play.fill")
                                .font(.headline)
                        }
                        .buttonStyle(.bordered)
                    }
                    
                    Button("Voir tous les rounds") {
                        showAllRounds()
                    }
                    .buttonStyle(.bordered)
                    .font(.caption)
                } else {
                    // Bouton quand le combat est terminé
                    NavigationLink(destination: FightResultView(fightResponse: fightResponse)) {
                        Text("Voir les résultats")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                }
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 20)
        }
        .navigationTitle("Combat en cours")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Afficher le premier round automatiquement
            if currentRoundIndex == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showNextRound()
                }
            }
        }
    }
    
    private func showNextRound() {
        guard currentRoundIndex < fightResponse.log.rounds.count else { return }
        
        withAnimation {
            currentRoundIndex += 1
        }
        
        // Si en mode auto, continuer
        if isAutoPlaying && currentRoundIndex < fightResponse.log.rounds.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                showNextRound()
            }
        } else if currentRoundIndex >= fightResponse.log.rounds.count {
            isAutoPlaying = false
        }
    }
    
    private func showAllRounds() {
        withAnimation {
            currentRoundIndex = fightResponse.log.rounds.count
        }
        isAutoPlaying = false
    }
    
    private func toggleAutoPlay() {
        isAutoPlaying.toggle()
        
        if isAutoPlaying {
            showNextRound()
        }
    }
}

// Une ligne pour un round
struct RoundRow: View {
    let round: FightRound
    let myBarbarianId: Int
    let myBarbarianName: String
    let opponentName: String
    
    @State private var appear = false
    
    var isMyAttack: Bool {
        round.actor == myBarbarianId
    }
    
    var attackerName: String {
        isMyAttack ? myBarbarianName : opponentName
    }
    
    var defenderName: String {
        isMyAttack ? opponentName : myBarbarianName
    }
    
    var body: some View {
        HStack(spacing: 10) {
            // Numéro du round
            Text("\(round.round)")
                .font(.caption)
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .background(Circle().fill(Color.blue))
            
            // Description de l'action
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(attackerName)
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(isMyAttack ? .green : .red)
                    
                    Image(systemName: round.hit ? "arrow.right" : "arrow.right.circle")
                        .foregroundColor(round.hit ? .orange : .gray)
                    
                    Text(defenderName)
                        .font(.subheadline)
                }
                
                if round.hit {
                    Text("💥 -\(round.damage) HP")
                        .font(.caption)
                        .foregroundColor(.red)
                        .bold()
                } else {
                    Text("🛡️ Esquivé !")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            // HP restants
            VStack {
                Text("\(round.hp_target_after)")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(round.hp_target_after < 10 ? .red : .primary)
                Text("HP")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(round.hit ? Color.red.opacity(0.1) : Color.gray.opacity(0.05))
        )
        .opacity(appear ? 1 : 0)
        .offset(y: appear ? 0 : 20)
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                appear = true
            }
        }
    }
}
