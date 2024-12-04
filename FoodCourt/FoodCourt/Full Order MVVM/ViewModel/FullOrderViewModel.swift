//
//  FullOrderViewModel.swift
//  FoodCourt
//
//  Created by Марк Киричко on 01.12.2024.
//

import Foundation

final class FullOrderViewModel: ObservableObject {
    
    @Published var isLoading = true
    @Published var products = [Product]()
    @Published var statuses = [StatusModel]()
    @Published var address = ""
    
    private var deliveryPrice = 0
    
    // MARK: - сервисы
    private let service = APIService()
    private let locationManager = LocationManager()
    private let settingsManager = SettingsManager()
    
    init() {
        getProducts()
        getDeliveryPrice()
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
                self.isLoading = false
            }
        }
    }
    
    func getDeliveryPrice() {
        deliveryPrice = settingsManager.getDeliveryPrice()
    }
    
    func getSum(by order: Order)-> Int {
        
        var sum = 0
        
        for product in order.products ?? [] {
            let prod = getProduct(by: product.productID)
            sum = sum + (prod.price * product.count)
        }
        
        if order.deliveryPoint != nil {
            sum += deliveryPrice
        }
        
        return sum
    }
    
    func getSum(price: Int, count: Int)-> Int {
        return price * count
    }
    
    func convertDate(order: Order)-> String {
        return order.preferredTime ?? ""
    }
    
    func convertPreferedTime(order: Order)-> String {
        if let time = order.preferredTime {
            return "Приготовить к: \(time)"
        } else {
            return ""
        }
    }
    
    func convertPrice(order: OrderModel)-> String {
        if order.order.deliveryPoint != nil {
            return "Итого: \(getSum(by: order.order)) ₽ (c доставкой)"
        } else {
            return "Итого: \(getSum(by: order.order)) ₽"
        }
    }
    
    func getLocationAddress(order: Order) {
        if let location = order.deliveryPoint {
            locationManager.getAddress(latitude: location.lat ?? 0, longtitude: location.lon ?? 0) { address, error in
                self.address = "Адрес доставки: \(address ?? "")"
            }
        } else {
            address = "Самовывоз"
        }
    }
}
