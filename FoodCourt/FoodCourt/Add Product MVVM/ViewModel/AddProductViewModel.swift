//
//  AddProductViewModel.swift
//  FoodCourt
//
//  Created by Марк Киричко on 29.11.2024.
//

import Foundation

final class AddProductViewModel: ObservableObject {
    
    @Published var product = Product(id: 0, photo: "", name: "", price: 0, deleted: false, description: "")
    @Published var currentCategory = CategoryModel(id: 0, name: "")
    @Published var categories = [CategoryModel]()
    @Published var price = ""
    
    // MARK: - сервисы
    let service = APIService()
    
    func setUpProduct(product: Product) {
        self.product = product
        self.price = String(product.price)
    }
    
    func getCategories() {
        service.getCategories { categories in
            DispatchQueue.main.async {
                self.currentCategory = categories[0]
                self.categories = categories
            }
        }
    }
    
    func handleChanges(completion: @escaping()->Void) {
        if product.id == 0 {
            createOrder(completion: completion)
        } else {
            editOrder(completion: completion)
        }
    }
    
    func titleForNavigation()-> String {
        if product.id == 0 {
            return "Добавить продукт"
        } else {
            return "Изменить продукт"
        }
    }
    
    func titleForButton()-> String {
        if product.id == 0 {
            return "Добавить"
        } else {
            return "Изменить"
        }
    }
    
    func createOrder(completion: @escaping()->Void) {
        service.createProduct(categoryID: currentCategory.id, product: product) {completion()}
    }
    
    func editOrder(completion: @escaping()->Void) {
        service.editProduct(categoryID: currentCategory.id, product: product) {completion()}
    }
    
    func convertText()-> String {
        return price.convertText()
    }
}
