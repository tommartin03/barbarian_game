//
//  BarbarianDetailView.swift
//  barbarian_game
//
//  Created by tplocal on 03/12/2025.
//
import SwiftUI

struct BarbarianDetailView: View {
    let barbarian: Barbarian

    var body: some View {
        VStack(spacing: 20) {
            Image("avatar_\(barbarian.avatar_id)")
                .resizable()
                .frame(width: 120, height: 120)
                .clipShape(Circle())

            Text(barbarian.name)
                .font(.largeTitle)

            VStack(alignment: .leading, spacing: 8) {
                Text("❤️ LOVE : \(barbarian.love)")
                Text("⭐ EXP : \(barbarian.exp)")
                
            }
            .font(.title3)

            Spacer()
        }
        .padding()
    }
}

