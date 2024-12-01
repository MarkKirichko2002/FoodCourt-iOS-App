//
//  RegistrationView.swift
//  FoodCourt
//
//  Created by Марк Киричко on 21.11.2024.
//

import SwiftUI

struct RegistrationView: View {
    
    @ObservedObject var viewModel = RegistrationViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isAuth {
                    ClientTabView()
                } else {
                    VStack {
                        Form {
                            Section("Как к вам обращаться") {
                                TextField("", text: $viewModel.client.name)
                            }
                            Section("Ваш номер телефона (начиная с 8)") {
                                TextField("", text: $viewModel.client.phone)
                            }
                            Section {
                                Button(action: {
                                    viewModel.handleRegistration()
                                }) {
                                    Text("Зарегистрироваться")
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                }
                                Button(action: {
                                    viewModel.isPresented.toggle()
                                }) {
                                    Text("Я повар")
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                }
                            }
                        }.navigationTitle("Добро пожаловать!")
                            .navigationBarTitleDisplayMode(.inline)
                            .alert(viewModel.alertText, isPresented: $viewModel.alert) {
                                Button("OK", role: .cancel) {}
                         }
                    }
                }
            }
        }
        .onChange(of: viewModel.client.phone) {
            viewModel.client.phone = viewModel.convertText()
        }.fullScreenCover(isPresented: $viewModel.isPresented) {
            NavigationView {
                CreateCookView()
            }.tint(.primary)
        }
    }
}

#Preview {
    RegistrationView()
}
