//
//  SettingsClientViewModel.swift
//  FoodCourt
//
//  Created by Марк Киричко on 16.11.2024.
//

import Foundation

final class SettingsClientViewModel: ObservableObject {
    
    @Published var isPresented = false
    @Published var client = Client(name: "", phone: "", fcmToken: "")
    
    // MARK: - сервисы
    private let service = APIService()
    private let settingsManager = SettingsManager()
    
    init() {
        setUpData()
    }
    
    func setUpData() {
        let phone = settingsManager.getPhone()
        let token = settingsManager.getToken()
        client.fcmToken = token
        service.getClient(phone: phone) { client in
            DispatchQueue.main.async {
                self.client = Client(name: client.name ?? "", phone: client.phone ?? "", fcmToken: token)
            }
        }
    }
    
    func convertText()-> String {
        return client.phone.convertText()
    }
    
    func handleChanges(completion: @escaping()->Void) {
        if !client.name.isEmpty {
            print("change")
            changeUser {
                completion()
            }
        } else {
            print("add")
            addUser {
                completion()
            }
        }
    }
    
    func addUser(completion: @escaping()->Void) {
        client.phone = String(client.phone.dropFirst())
        service.addUser(client: client) { client in
            self.saveData(client: client)
            completion()
        }
    }
    
    func changeUser(completion: @escaping()->Void) {
        client.phone = String(client.phone.dropFirst())
        print(client)
        service.changeUser(client: client) {
            UserDefaults.standard.set(self.client.phone, forKey: "phone")
            completion()
        }
    }
    
    func saveData(client: ClientModel) {
        UserDefaults.standard.set(client.phone, forKey: "phone")
        UserDefaults.standard.set(client.id, forKey: "id")
        UserDefaults.standard.set(true, forKey: "isAuth")
    }
}
