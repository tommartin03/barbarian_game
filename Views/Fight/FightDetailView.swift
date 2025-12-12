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
    
    var myBarbarianId: Int {
        vm.barbarian?.id ?? 0
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Déroulement du combat")
                .font(.title2)
                .padding()
            
            // Avatars des deux barbares
            HStack(spacing: 40) {
                VStack {
                    if let myBar = vm.barbarian {
                        AsyncImage(url: vm.avatarURL(avatarID: myBar.avatar_id)) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        
                        Text(myBar.name)
                            .font(.caption)
                    }
                }
                
                Text("VS")
                    .font(.title3)
                
                VStack {
                    AsyncImage(url: vm.avatarURL(avatarID: fightResponse.opponent.avatar_id)) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    
                    Text(fightResponse.opponent.name)
                        .font(.caption)
                }
            }
            .padding()
            
            List(fightResponse.log.rounds) { round in
                HStack {
                    Text("Round \(round.round)")
                        .bold()
                    
                    Spacer()
                    
                    // Qui attaque
                    if round.actor == myBarbarianId {
                        Text("Vous attaquez")
                            .foregroundColor(.green)
                    } else {
                        Text("\(fightResponse.opponent.name) attaque")
                            .foregroundColor(.red)
                    }
                    
                    Spacer()
                    
                    if round.hit {
                        Text("-\(round.damage) HP")
                            .foregroundColor(.red)
                    } else {
                        Text("Raté")
                            .foregroundColor(.gray)
                    }
                    
                    Text("(\(round.hp_target_after) HP)")
                        .foregroundColor(.blue)
                }
            }
            
            NavigationLink(destination: FightResultView(fightResponse: fightResponse)) {
                Text("Voir les résultats")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .navigationTitle("Combat")
    }
}
