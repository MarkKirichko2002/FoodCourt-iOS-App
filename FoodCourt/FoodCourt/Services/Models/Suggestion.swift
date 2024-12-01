//
//  Suggestion.swift
//  FoodCourt
//
//  Created by Марк Киричко on 11.11.2024.
//

import Foundation

// MARK: - Adress
struct Address: Codable {
    let suggestions: [Suggestion]
}

// MARK: - Suggestion
struct Suggestion: Codable {
    let value, unrestrictedValue: String
    let data: [String: String?]
    
    enum CodingKeys: String, CodingKey {
        case value
        case unrestrictedValue = "unrestricted_value"
        case data
    }
}

// MARK: - DataModel
struct DataModel: Codable {
    let house: String
    let street: String?
    let flat: String?
    let geo_lat: String
    let geo_lon: String
    
    enum CodingKeys: String, CodingKey {
        case house
        case street
        case flat
        case geo_lat
        case geo_lon
    }
}

// MARK: - Adress
struct Adress: Codable {
    let query: String
    let count: Int
    let locations: [Location]
}

// MARK: - Location
struct Location: Codable {
    let city: String
}
