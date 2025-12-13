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
        VStack(spacing: 0) {
            Spacer()
            
            // Titre
            Text("Créer votre barbare")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 30)
            
            // Carte grise
            VStack(spacing: 20) {
                // Label avatars
                Text("Choisissez un avatar")
                    .font(.headline)
                
                // Avatars
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(vm.avatars) { avatar in
                            AsyncImage(url: avatar.fullURL) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(selectedAvatar == avatar.id ? Color.blue : Color.gray, lineWidth: 3)
                            )
                            .onTapGesture {
                                selectedAvatar = avatar.id
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                Divider()
                    .padding(.vertical, 10)
                
                // Nom
                VStack(alignment: .leading, spacing: 8) {
                    Text("Nom du barbare")
                        .font(.headline)
                    
                    TextField("Entrez un nom", text: $name)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 30)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(15)
            .padding(.horizontal, 30)
            
            // Bouton
            Button {
                guard let avatarID = selectedAvatar, !name.isEmpty else { return }
                Task {
                    await vm.createBarbarian(name: name, avatarID: avatarID)
                    goToMenu = true
                }
            } label: {
                Text("Créer mon barbare")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 30)
            .padding(.top, 30)
            .disabled(name.isEmpty || selectedAvatar == nil)
            
            Spacer()
            Spacer()
        }
        .task {
            await vm.loadAvatars()
        }
        .fullScreenCover(isPresented: $goToMenu) {
            MenuView()
        }
    }
}
