//
//  SettingsManager.swift
//  FoodCourt
//
//  Created by Марк Киричко on 20.11.2024.
//

import Foundation

final class SettingsManager {
    
    func getDeliveryPrice()-> Int {
        return UserDefaults.standard.object(forKey: "deliveryPrice") as? Int ?? 150
    }
    
    func getPhone()-> String {
        return UserDefaults.standard.object(forKey: "phone") as? String ?? ""
    }
    
    func getIsAuth()-> Bool {
        return UserDefaults.standard.object(forKey: "isAuth") as? Bool ?? false
    }
    
    func getIsCook()-> Bool {
        return UserDefaults.standard.object(forKey: "isCook") as? Bool ?? false
    }
    
    func getToken()-> String {
        return UserDefaults.standard.object(forKey: "token") as? String ?? ""
    }
    
    func getID()-> Int {
        return UserDefaults.standard.object(forKey: "id") as? Int ?? 0
    }
}
