//
//  ClientModel.swift
//  FoodCourt
//
//  Created by Марк Киричко on 16.11.2024.
//

import Foundation

struct Client: Codable {
    var name: String
    var phone: String
    var fcmToken: String
}

struct ClientResponse: Codable {
    let code: Int
    let client: ClientModel
}

struct ResponseModel: Codable {
    let client: ClientModel
    let code: Int
}

struct ClientModel: Codable {
    let id: Int?
    var name: String?
    var phone: String?
}
