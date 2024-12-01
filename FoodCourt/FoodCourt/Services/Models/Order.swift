//
//  Order.swift
//  FoodCourt
//
//  Created by Марк Киричко on 03.11.2024.
//

import Foundation

struct OrderModel: Identifiable, Codable {
    let id = UUID()
    let order: Order
    var status: Status
    let client: ClientModel?
}

// MARK: - OrderModel
struct Order: Identifiable, Codable {
    let id: Int?
    let created, preferredTime: String?
    let deliveryPoint: DeliveryPoint?
    let products: [ProductsOrder]?
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(created, forKey: .created)
        try container.encode(preferredTime, forKey: .preferredTime)
        try container.encode(deliveryPoint, forKey: .deliveryPoint)
        try container.encode(products, forKey: .products)
    }
}


// MARK: - Product
struct ProductsOrder: Codable {
    
    let count, productID: Int
    
    enum CodingKeys: String, CodingKey {
        case count
        case productID = "productId"
    }
}

struct DeliveryPoint: Codable {
    let lat: Double?
    let lon: Double?
}

struct Status: Codable {
    let statusId: Int
}

struct StatusModel: Codable, Hashable {
    let statusId: Int
    let statusName: String
}
