//
//  CookOrdersListViewModel.swift
//  FoodCourt
//
//  Created by Марк Киричко on 01.12.2024.
//

import Foundation

final class CookOrdersListViewModel: ObservableObject {
    
    var orders = [OrderModel]()
    @Published var sections = [OrderSection]()
    @Published var isLoading = true
    @Published var selectedSection: String? = nil
    @Published var products = [Product]()
    @Published var currentStatus = StatusModel(statusId: 0, statusName: "")
    @Published var statuses = [StatusModel]()
    @Published var isScroll = false
    
    // MARK: - сервисы
    private let service = APIService()
    private let dateManager = DateManager()
    private let locationManager = LocationManager()
    
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
    
    func getStatus(by id: Int)-> StatusModel {
        for status in statuses {
            if status.statusId == id {
                return status
            }
        }
        return  StatusModel(statusId: 1, statusName: "Новый")
    }
    
    func getStatuses() {
        service.getStatuses { statuses in
            DispatchQueue.main.async {
                self.statuses = statuses
                self.currentStatus = statuses[0]
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
    
    func getSum(price: Int, count: Int)-> Int {
        return price * count
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
    
    func convertClientInfo(client: ClientModel?)-> String {
        return "Заказал: \(client?.name ?? ""), +7\(client?.phone ?? "")"
    }
    
    func convertPreferedTime(order: Order)-> String {
        if let time = order.preferredTime {
            return "Приготовить к: \(time)"
        } else {
            return order.created ?? ""
        }
    }
    
    func getLocationAddress(order: Order, completion: @escaping(String)->Void) {
        if let location = order.deliveryPoint {
            locationManager.getAddress(latitude: location.lat ?? 0, longtitude: location.lon ?? 0) { address, error in
                completion(address ?? "")
            }
        } else {
            completion("")
        }
    }
    
    func editOrder(statusId: Int, order: Order) {
        service.editOrder(statusId: statusId, orderId: order.id ?? 0) {
            self.getOrders()
        }
    }
    
    func observeOrder() {
        NotificationCenter.default.addObserver(forName: Notification.Name("order created"), object: nil, queue: nil) { _ in
            self.getOrders()
        }
    }
}
