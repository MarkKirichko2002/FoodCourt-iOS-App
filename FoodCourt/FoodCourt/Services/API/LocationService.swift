//
//  LocationService.swift
//  FoodCourt
//
//  Created by Марк Киричко on 11.11.2024.
//

import Foundation

final class LocationService {
    
    private let firebaseManager = FirebaseManager()
    var token = ""
    
    init() {
        firebaseManager.getConfigArray(key: "dadata_api_keys") { arr in
            self.token = arr[0].token
        }
    }
    
    func getSuggestions(text: String, completion: @escaping([Suggestion])->Void) {
        var request = URLRequest(url: URL(string: "http://suggestions.dadata.ru/suggestions/api/4_1/rs/suggest/address")!)
        let json = """
                {
                    "query": "\(text)",
                    "count": 5,
                    "locations": [
                        {
                            "city": "Армавир"
                        }
                    ]
                }
            """.data(using: .utf8) ?? Data()
        request.httpMethod = "POST"
        request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = json
        
        if let jsonString = String(data: json, encoding: .utf8) {
            print(jsonString)
        } else {
            print("Не удалось преобразовать данные в строку.")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Ошибка при выполнении запроса: \(error)")
                return
            }
            guard let data = data else {return}
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print(jsonString)
            } else {
                print("Не удалось преобразовать данные в строку.")
            }
            
            do {
                let result = try JSONDecoder().decode(Address.self, from: data)
                completion(result.suggestions)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func createJson(data: Codable)-> Data {
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        encoder.keyEncodingStrategy = .useDefaultKeys
        
        do {
            let data = try encoder.encode(data)
            return data
        } catch {
            print(error)
        }
        return Data()
    }
}
