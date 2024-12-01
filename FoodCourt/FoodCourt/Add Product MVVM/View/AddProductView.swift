//
//  AddProductView.swift
//  FoodCourt
//
//  Created by Марк Киричко on 29.11.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct AddProductView: View {
    
    @ObservedObject var viewModel = AddProductViewModel()
    @Environment(\.dismiss) var dismiss
    @Binding var isChanged: Bool
    var product: Product
    
    var body: some View {
        Form {
            Section() {
                ProductCell(product: $viewModel.product)
            }
            
            Section("Имя") {
                TextField("", text: $viewModel.product.name)
            }
            
            Section("Описание") {
                TextField("", text: $viewModel.product.description)
            }
            
            Section("Цена продукта") {
                TextField("", text: $viewModel.price)
            }
            
            Section("Категория продукта") {
                Picker("", selection: $viewModel.currentCategory) {
                    ForEach(viewModel.categories, id: \.self) { category in
                        Text(category.name)
                    }
                }.pickerStyle(MenuPickerStyle())
            }
            
            Section("Ссылка на изображение") {
                TextField("", text: $viewModel.product.photo)
            }
            
            Button(action: {
                viewModel.handleChanges {
                    DispatchQueue.main.async {
                        self.isChanged.toggle()
                        self.dismiss()
                    }
                }
            }) {
                Text(viewModel.titleForButton())
                    .fontWeight(.bold)
            }
            
        }.navigationTitle(viewModel.titleForNavigation())
            .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.setUpProduct(product: product)
            viewModel.getCategories()
        }.onChange(of: viewModel.price) { oldValue, newValue in
            viewModel.price = viewModel.convertText()
            viewModel.product.price = Int(viewModel.convertText()) ?? 0
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    dismiss()
                }) {
                    Image("cross")
                }
            }
        }
    }
}

//#Preview {
//    AddProductView(product: Product(id: 0, photo: "", name: "", price: 0, deleted: false, description: ""))
//}
