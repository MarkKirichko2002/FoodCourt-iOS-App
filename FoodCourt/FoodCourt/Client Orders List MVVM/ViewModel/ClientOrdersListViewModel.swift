//
//  ClientOrdersListViewModel.swift
//  FoodCourt
//
//  Created by Марк Киричко on 03.11.2024.
//

import Foundation

final class ClientOrdersListViewModel: ObservableObject {
    
    var orders = [OrderModel]()
    @Published var sections = [OrderSection]()
    @Published var isLoading = true
    @Published var selectedSection: String? = nil
    @Published var products = [Product]()
    @Published var isScroll = false
    
    private var statuses = [StatusModel]()
    
    // MARK: - сервисы
    private let service = APIService()
    private let dateManager = DateManager()
    
    init() {
        getOrders()
        observeOrder()
    }
    
    func getOrders() {
        sections = []
        isLoading = true
        service.getOrders { orders in
            DispatchQueue.main.async {
                self.orders = orders
                self.getProducts()
            }
        }
    }
    
    func getProducts() {
        service.getMenu { categories in
            for category in categories {
                for product in category.products {
                    DispatchQueue.main.async {
                        self.products.append(product)
                    }
                }
            }
            self.getStatuses()
        }
    }
    
    func getProduct(by id: Int)-> Product {
        for product in products {
            if product.id == id {
                return product
            }
        }
        return products[0]
    }
    
    func getStatus(by id: Int)-> String {
        for status in statuses {
            if status.statusId == id {
                return status.statusName
            }
        }
        return ""
    }
    
    func getStatuses() {
        service.getStatuses { statuses in
            DispatchQueue.main.async {
                self.statuses = statuses
                self.createSections()
                self.isLoading = false
            }
        }
    }
    
    func getSum(by order: Order)-> Int {
        
        var sum = 0
        
        for product in order.products ?? [] {
            let prod = getProduct(by: product.productID)
            sum = sum + (prod.price * product.count)
        }
        
        return sum
    }
    
    func createSections() {
        for status in statuses {
            let filteredOrders = orders.filter({ $0.status.statusId == status.statusId })
            if !filteredOrders.isEmpty {
                let model = OrderSection(name: status.statusName, orders: filteredOrders)
                sections.append(model)
            }
        }
        if !sections.isEmpty {
            selectedSection = sections[0].name
        }
    }
    
    func convertDate(order: Order)-> String {
        return order.preferredTime ?? ""
    }
    
    func observeOrder() {
        NotificationCenter.default.addObserver(forName: Notification.Name("order created"), object: nil, queue: nil) { _ in
            self.getOrders()
        }
    }
}
