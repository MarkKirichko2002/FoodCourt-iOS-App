//
//  Product.swift
//  FoodCourt
//
//  Created by Марк Киричко on 14.10.2024.
//

import Foundation

struct Product: Identifiable, Codable, Hashable {
    let id: Int
    var photo: String
    var name: String
    var price: Int
    var deleted: Bool
    var description: String
}

struct Category: Identifiable, Codable, Hashable {
    var id: UUID?
    let name: String
    var products: [Product]
}

struct CategoryModel: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
}

struct Menu: Identifiable, Codable {
    let id: UUID
    let categories: [Category]
}
