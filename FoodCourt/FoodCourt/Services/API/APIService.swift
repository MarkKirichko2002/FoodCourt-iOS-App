//
//  APIService.swift
//  FoodCourt
//
//  Created by Марк Киричко on 23.10.2024.
//

import Foundation

final class APIService {
    
    let token = UserDefaults.standard.object(forKey: "token") as? String ?? ""
    
    func getMenu(completion: @escaping([Category])->Void) {
        URLSession.shared.dataTask(with: URL(string: "https://merqury.ddns.net/menu/get")!) { data, error, _ in
            guard let data = data else {return}
            
            do {
                let result = try JSONDecoder().decode([Category].self, from: data)
                completion(result)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func getCategories(completion: @escaping([CategoryModel])->Void) {
        URLSession.shared.dataTask(with: URL(string: "https://merqury.ddns.net/categories/get")!) { data, error, _ in
            guard let data = data else {return}
            
            do {
                let result = try JSONDecoder().decode([CategoryModel].self, from: data)
                completion(result)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func createProduct(categoryID: Int, product: Product, completion: @escaping()->Void) {
        var request = URLRequest(url: URL(string: "https://merqury.ddns.net/menu/add?categoryId=\(categoryID)")!)
        let json = createJson(data: product)
        print(json)
        request.httpMethod = "POST"
        request.setValue(token, forHTTPHeaderField: "Authorization")
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
            
            if let httpResponse = response as? HTTPURLResponse {
                if (200...299).contains(httpResponse.statusCode) {
                    print("Запрос выполнен успешно: \(httpResponse.statusCode)")
                    completion()
                } else {
                    print("Ошибка сервера: \(httpResponse.statusCode)")
                    if let data = data, let responseString = String(data: data, encoding: .utf8) {
                        print("Ответ сервера: \(responseString)")
                    }
                }
            }
        }.resume()
    }
    
    func editProduct(categoryID: Int, product: Product, completion: @escaping()->Void) {
        var request = URLRequest(url: URL(string: "https://merqury.ddns.net/menu/patch?categoryId=\(categoryID)")!)
        let json = createJson(data: product)
        print(json)
        request.httpMethod = "PATCH"
        request.setValue(token, forHTTPHeaderField: "Authorization")
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
            
            if let httpResponse = response as? HTTPURLResponse {
                if (200...299).contains(httpResponse.statusCode) {
                    print("Запрос выполнен успешно: \(httpResponse.statusCode)")
                    completion()
                } else {
                    print("Ошибка сервера: \(httpResponse.statusCode)")
                    if let data = data, let responseString = String(data: data, encoding: .utf8) {
                        print("Ответ сервера: \(responseString)")
                    }
                }
            }
        }.resume()
    }
    
    func deleteProduct(productID: Int, completion: @escaping()->Void) {
        var request = URLRequest(url: URL(string: "https://merqury.ddns.net/menu/delete?id=\(productID)")!)
        request.httpMethod = "DELETE"
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Ошибка при выполнении запроса: \(error)")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if (200...299).contains(httpResponse.statusCode) {
                    print("Запрос выполнен успешно: \(httpResponse.statusCode)")
                    completion()
                } else {
                    print("Ошибка сервера: \(httpResponse.statusCode)")
                    if let data = data, let responseString = String(data: data, encoding: .utf8) {
                        print("Ответ сервера: \(responseString)")
                    }
                }
            }
        }.resume()
    }
    
    func createOrder(location: DeliveryPoint?, time: String?, products: [Product : Int], completion: @escaping()->Void) {
        let prods = products.map { ProductsOrder(count: $0.value, productID: $0.key.id)}
        let order = Order(id: nil, created: nil, preferredTime: time, deliveryPoint: location, products: prods)
        var request = URLRequest(url: URL(string: "https://merqury.ddns.net/orders/add")!)
        let json = createJson(data: order)
        print(json)
        request.httpMethod = "POST"
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = json
        
        if let jsonString = String(data: json, encoding: .utf8) {
            print(jsonString)  // Вывод сырого JSON в консоль
        } else {
            print("Не удалось преобразовать данные в строку.")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Ошибка при выполнении запроса: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if (200...299).contains(httpResponse.statusCode) {
                    print("Запрос выполнен успешно: \(httpResponse.statusCode)")
                    completion()
                } else {
                    print("Ошибка сервера: \(httpResponse.statusCode)")
                    if let data = data, let responseString = String(data: data, encoding: .utf8) {
                        print("Ответ сервера: \(responseString)")
                    }
                }
            }
        }.resume()
    }
    
    func getOrders(completion: @escaping([OrderModel])->Void) {
        var request = URLRequest(url: URL(string: "https://merqury.ddns.net/orders/get")!)
        
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, error, _ in
            guard let data = data else {return}
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print(jsonString)
            } else {
                print("Не удалось преобразовать данные в строку.")
            }
            
            do {
                let result = try JSONDecoder().decode([OrderModel].self, from: data)
                completion(result)
            } catch {
                print(error)
            }
            
        }.resume()
    }
    
    func editOrder(statusId: Int, orderId: Int, completion: @escaping()->Void) {
        var request = URLRequest(url: URL(string: "https://merqury.ddns.net/orders/patch?statusId=\(statusId)&orderId=\(orderId)")!)
        
        request.httpMethod = "PATCH"
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, error, _ in
            guard let data = data else {return}
            completion()
            
        }.resume()
    }
    
    func getWorkingCooks(completion: @escaping(String)->Void) {
        
        URLSession.shared.dataTask(with: URL(string: "https://merqury.ddns.net/cooks/working")!) { data, error, _ in
            guard let data = data else {return}
            
            if let isWorking = String(data: data, encoding: .utf8) {
                print("Работает: \(isWorking)")
                completion(isWorking)
            } else {
                print("Не удалось преобразовать данные в строку.")
            }
            
        }.resume()
    }
    
    func getStatuses(completion: @escaping([StatusModel])->Void) {
        var request = URLRequest(url: URL(string: "https://merqury.ddns.net/statuses/get")!)
        
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, error, _ in
            guard let data = data else {return}
            
            do {
                let result = try JSONDecoder().decode([StatusModel].self, from: data)
                completion(result)
            } catch {
                print(error)
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
    
    func addUser(client: Client, completion: @escaping(ClientModel)->Void) {
        var request = URLRequest(url: URL(string: "https://merqury.ddns.net/clients/add")!)
        let json = createJson(data: client)
        
        request.httpMethod = "POST"
        request.setValue(client.fcmToken, forHTTPHeaderField: "Authorization")
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
            
            if let httpResponse = response as? HTTPURLResponse {
                if (200...299).contains(httpResponse.statusCode) {
                    do {
                        let result = try JSONDecoder().decode(ResponseModel.self, from: data ?? Data())
                        print(result.client)
                        completion(result.client)
                    } catch {
                        print(error)
                    }
                } else {
                    print("Ошибка сервера: \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }
    
    func changeUser(client: Client, completion: @escaping()->Void) {
        var request = URLRequest(url: URL(string: "https://merqury.ddns.net/clients/patch")!)
        let json = createJson(data: client)
        
        request.httpMethod = "PATCH"
        request.setValue(client.fcmToken, forHTTPHeaderField: "Authorization")
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
            
            if let httpResponse = response as? HTTPURLResponse {
                if (200...299).contains(httpResponse.statusCode) {
                    completion()
                } else {
                    print("Ошибка сервера: \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }
    
    func getClient(phone: String, completion: @escaping(ClientModel)->Void) {
        print("phone: \(phone)")
        URLSession.shared.dataTask(with: URL(string: "https://merqury.ddns.net/clients/get?phone=\(phone)")!) { data, error, _ in
            guard let data = data else {return}
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print(jsonString)
            } else {
                print("Не удалось преобразовать данные в строку.")
            }
            
            do {
                let result = try JSONDecoder().decode(ClientModel.self, from: data)
                completion(result)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func createCook(cook: Cook, completion: @escaping(CookModel)->Void) {
        var request = URLRequest(url: URL(string: "https://merqury.ddns.net/cooks/add")!)
        let json = createJson(data: cook)
        print(json)
        request.httpMethod = "POST"
        request.setValue("123", forHTTPHeaderField: "Authorization")
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
            
            if let httpResponse = response as? HTTPURLResponse {
                if (200...299).contains(httpResponse.statusCode) {
                    print("Запрос выполнен успешно: \(httpResponse.statusCode)")
                    do {
                        let result = try JSONDecoder().decode(CookResponse.self, from: data ?? Data())
                        completion(result.cook)
                    } catch {
                        print(error)
                    }
                } else {
                    print("Ошибка сервера: \(httpResponse.statusCode)")
                    if let data = data, let responseString = String(data: data, encoding: .utf8) {
                        print("Ответ сервера: \(responseString)")
                    }
                }
            }
        }.resume()
    }
    
    func deleteCook(completion: @escaping()->Void) {
        let id = UserDefaults.standard.object(forKey: "id") as? Int ?? 0
        var request = URLRequest(url: URL(string: "https://merqury.ddns.net/cooks/delete?id=\(id)")!)
        request.httpMethod = "DELETE"
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Ошибка при выполнении запроса: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if (200...299).contains(httpResponse.statusCode) {
                    print("Запрос выполнен успешно: \(httpResponse.statusCode)")
                    completion()
                } else {
                    print("Ошибка сервера: \(httpResponse.statusCode)")
                    if let data = data, let responseString = String(data: data, encoding: .utf8) {
                        print("Ответ сервера: \(responseString)")
                    }
                }
            }
        }.resume()
    }
    
    func getCook(phone: String, completion: @escaping(CookItem)->Void) {
        URLSession.shared.dataTask(with: URL(string: "https://merqury.ddns.net/cooks/get?phone=\(phone)")!) { data, error, _ in
            guard let data = data else {return}
            
            do {
                let result = try JSONDecoder().decode(CookItem.self, from: data)
                completion(result)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func changeCook(cook: CookModel, completion: @escaping()->Void) {
        var request = URLRequest(url: URL(string: "https://merqury.ddns.net/cooks/patch")!)
        let json = createJson(data: cook)
        request.httpMethod = "PATCH"
        request.setValue(token, forHTTPHeaderField: "Authorization")
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
            
            if let httpResponse = response as? HTTPURLResponse {
                if (200...299).contains(httpResponse.statusCode) {
                    completion()
                } else {
                    print("Ошибка сервера: \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }
    
    func updateToken(isCook: Bool, fcm: FcmModel, id: Int, completion: @escaping()->Void) {
        var url = ""
        if isCook {
            url = "https://merqury.ddns.net/cooks/updateFcm?id=\(id)"
        } else {
            url = "https://merqury.ddns.net/clients/updateFcm?id=\(id)"
        }
        var request = URLRequest(url: URL(string: url)!)
        let json = createJson(data: fcm)
        request.httpMethod = "PATCH"
        request.setValue(fcm.fcm, forHTTPHeaderField: "Authorization")
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
            
            if let httpResponse = response as? HTTPURLResponse {
                if (200...299).contains(httpResponse.statusCode) {
                    completion()
                } else {
                    print("Ошибка сервера: \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }
}
