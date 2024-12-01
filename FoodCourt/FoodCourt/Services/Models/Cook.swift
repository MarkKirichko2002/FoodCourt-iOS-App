//
//  Cook.swift
//  FoodCourt
//
//  Created by Марк Киричко on 20.11.2024.
//

import Foundation

struct CookResponse: Codable {
    let code: Int?
    let cook: CookModel
}

struct Cook: Codable {
    var firstName: String
    var lastName: String
    var fatherName: String
    var fcmToken: String
    var phone: String
}

struct CookModel: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let fatherName: String
    let phone: String
}

struct CookItem: Codable {
    let firstName: String
    let lastName: String
    let fatherName: String
    let phone: String
}
