//
//  CreateBarbarianView.swift
//  barbarian_game
//
//  Created by tplocal on 03/12/2025.
//
import SwiftUI
struct CreateBarbarianView: View {
    @EnvironmentObject var vm: BarbarianViewModel
    @State private var name = ""
    @State private var selectedAvatar: Int? = nil
    @State private var goToMenu = false

    var body: some View {
        VStack {
            TextField("Nom du barbare", text: $name)
                .padding()
                .textFieldStyle(.roundedBorder)

            ScrollView(.horizontal) {
                HStack(spacing: 16) {
                    ForEach(vm.avatars) { avatar in
                        AsyncImage(url: avatar.fullURL) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(selectedAvatar == avatar.id ? Color.blue : Color.gray, lineWidth: 3)
                        )
                        .onTapGesture { selectedAvatar = avatar.id }
                    }
                }
                .padding()
            }

            Button("Créer") {
                guard let avatarID = selectedAvatar, !name.isEmpty else { return }
                Task {
                    await vm.createBarbarian(name: name, avatarID: avatarID)
                    goToMenu = true
                }
            }
        }
        .onAppear {
            Task { await vm.loadAvatars() }
        }
        .fullScreenCover(isPresented: $goToMenu) {
            MenuView()
        }
    }
}
