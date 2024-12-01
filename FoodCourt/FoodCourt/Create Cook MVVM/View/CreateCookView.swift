//
//  CreateCookView.swift
//  FoodCourt
//
//  Created by Марк Киричко on 16.11.2024.
//

import SwiftUI

struct CreateCookView: View {
    
    @ObservedObject var viewModel = CreateCookViewModel()
    @Environment(\.dismiss) var dismiss
    
    let cookTabView = CookTabView()
    
    var body: some View {
        VStack {
            if viewModel.isChanged {
                cookTabView
            } else {
                VStack {
                    Form {
                        Section("Ключ") {
                            TextField("", text: $viewModel.key)
                        }
                        Section("ФИО") {
                            TextField("", text: $viewModel.fio)
                        }
                        Section("Ваш номер телефона (начиная с 8)") {
                            TextField("", text: $viewModel.phone)
                        }
                        Section {
                            Button(action: {
                                viewModel.saveCook()
                            }) {
                                Text("Зарегистрироваться")
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                }
                .navigationTitle("Добавить повара")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            dismiss()
                        }) {
                            Image("cross")
                        }
                    }
                }
                .alert(viewModel.alertText, isPresented: $viewModel.alert) {
                    Button("OK", role: .cancel) {}
                }
                .onChange(of: viewModel.phone) {
                    viewModel.phone = viewModel.convertText()
                }
            }
        }
    }
}

#Preview {
    CreateCookView()
}
