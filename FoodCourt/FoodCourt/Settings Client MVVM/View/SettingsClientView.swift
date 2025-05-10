//
//  SettingsClientView.swift
//  FoodCourt
//
//  Created by Марк Киричко on 14.11.2024.
//

import SwiftUI

struct SettingsClientView: View {
    
    @ObservedObject var viewModel = SettingsClientViewModel()
    
    var body: some View {
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
                        viewModel.handleChanges {
                            
                        }
                    }) {
                        Text("Сохранить")
                            .fontWeight(.bold)
                    }
                    Button(action: {
                        viewModel.isPresented.toggle()
                    }) {
                        Text("Я повар")
                            .fontWeight(.bold)
                    }
                }
            }.navigationTitle("Настройки")
        }
        .onChange(of: viewModel.client.phone) {
            viewModel.client.phone = viewModel.convertText()
        }
        .fullScreenCover(isPresented: $viewModel.isPresented) {
            NavigationView {
                CreateCookView()
            }
        }
    }
}

//#Preview {
//    SettingsClientView()
//}
