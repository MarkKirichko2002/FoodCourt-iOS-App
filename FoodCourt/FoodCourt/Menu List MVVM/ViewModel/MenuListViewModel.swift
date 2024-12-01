//
//  MenuListViewModel.swift
//  FoodCourt
//
//  Created by Марк Киричко on 23.10.2024.
//

import Foundation

final class MenuListViewModel: ObservableObject {
    
    @Published var categories = [Category]()
    @Published var isLoading = true
    @Published var selectedCategory: String? = nil
    @Published var isPresented = false
    @Published var isChanged = false
    @Published var currentProduct = Product(id: 228, photo: "", name: "", price: 0, deleted: false, description: "")
    @Published var isScroll = false
    
    // MARK: - сервисы
    private let apiService = APIService()
    private let settingsManager = SettingsManager()
    
    init() {
        getMenu()
    }
    
    func getMenu() {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        apiService.getMenu { categories in
            DispatchQueue.main.async {
                self.selectedCategory = categories[0].name
                self.categories = categories
                self.filterProducts()
                self.isLoading = false
            }
        }
    }
    
    func filterProducts() {
        for i in 0..<categories.count {
            categories[i].products = categories[i].products.filter({ !$0.deleted }).sorted(by: { $0.name < $1.name })
        }
    }
    
    func deleteProduct(product: Product) {
        apiService.deleteProduct(productID: product.id) {
            self.getMenu()
        }
    }
    
    func getIsCook()-> Bool {
        return settingsManager.getIsCook()
    }
    
    func getSum(by products: [Product : Int])-> Int {
        
        var sum = 0
        
        for product in products {
            sum = sum + (product.key.price * product.value)
        }
        
        return sum
    }
    
    func resetCurrentProduct() {
        currentProduct = Product(id: 0, photo: "", name: "", price: 0, deleted: false, description: "")
    }
}
