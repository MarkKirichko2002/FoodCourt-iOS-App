//
//  SettingsCookView.swift
//  FoodCourt
//
//  Created by Марк Киричко on 20.11.2024.
//

import SwiftUI

struct SettingsCookView: View {
    
    @ObservedObject var viewModel = SettingsCookViewModel()
    
    var body: some View {
        VStack {
            Form {
                Section("Фамилия") {
                    TextField("", text: $viewModel.cook.lastName)
                }
                Section("Имя") {
                    TextField("", text: $viewModel.cook.firstName)
                }
                Section("Отчество") {
                    TextField("", text: $viewModel.cook.fatherName)
                }
                Section {
                    Button(action: {
                        viewModel.handleChanges() {
                            
                        }
                    }) {
                        Text("Сохранить")
                            .fontWeight(.bold)
                    }
                    
                    Button(action: {
                        viewModel.deleteCook()
                    }) {
                        Text("Удалить роль повара")
                            .fontWeight(.bold)
                    }
                }
            }
        }.navigationTitle("Настройки")
            .onChange(of: viewModel.cook.phone) {
                viewModel.cook.phone = viewModel.convertText()
         }
        .fullScreenCover(isPresented: $viewModel.isDeleted) {
            RegistrationView()
        }
    }
}

//#Preview {
//    SettingsCookView()
//}
