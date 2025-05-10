//
//  UserDefaults + Extensions.swift
//  FoodCourt
//
//  Created by Марк Киричко on 02.12.2024.
//

import Foundation

extension UserDefaults {
    
    static func saveData<T: Encodable>(object: T, key: String, completion: @escaping()->Void) {
        do {
            let data = try JSONEncoder().encode(object)
            UserDefaults.standard.setValue(data, forKey: key)
            completion()
        } catch {
            print(error)
        }
    }
    
    static func loadData<T: Decodable>(type: T.Type, key: String)-> T? {
        do {
            if let data = UserDefaults.standard.data(forKey: key) {
                let object = try JSONDecoder().decode(T.self, from: data)
                print(object)
                return object
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    static func saveArray(array: [Any], key: String, completion: @escaping()->Void) {
        UserDefaults.standard.setValue(array, forKey: key)
        completion()
    }
}
