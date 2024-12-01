//
//  ProfileView.swift
//  FoodCourt
//
//  Created by Марк Киричко on 14.11.2024.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var viewModel = ProfileViewModel()
    @State var isPresented = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5, anchor: .center)
                } else {
                    VStack(spacing: 30) {
                        Image("profile icon")
                            .resizable()
                            .frame(width: 70, height: 70)
                        Text(viewModel.profile.name ?? "Нет имени")
                            .font(.system(size: 18, weight: .bold))
                        Text(viewModel.profile.phone ?? "Нет телефона")
                            .font(.system(size: 18, weight: .medium))
                    }
                }
            }.navigationTitle("Профиль")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            isPresented.toggle()
                        }) {
                            Image("settings")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 25, height: 25)
                        }
                    }
                }
                .navigationDestination(isPresented: $isPresented) {
                    if viewModel.getIsCook() {
                        SettingsCookView()
                            .toolbar(.hidden, for: .tabBar)
                    } else {
                        SettingsClientView()
                            .toolbar(.hidden, for: .tabBar)
                    }
             }
        }
    }
}

#Preview {
    ProfileView()
}
