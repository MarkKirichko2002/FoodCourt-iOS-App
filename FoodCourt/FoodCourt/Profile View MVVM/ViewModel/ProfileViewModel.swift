//
//  ProfileViewModel.swift
//  FoodCourt
//
//  Created by Марк Киричко on 20.11.2024.
//

import Foundation

final class ProfileViewModel: ObservableObject {
    
    // MARK: - сервисы
    private let settingsManager = SettingsManager()
    private let service = APIService()
    
    @Published var profile = ClientModel(id: 0, name: "Загрузка...", phone: "Загрузка...")
    @Published var isLoading = true
    
    init() {
        getData()
    }
    
    func getData() {
        let phone = settingsManager.getPhone()
        let isCook = settingsManager.getIsCook()
        if isCook {
            getCook(phone: phone)
        } else {
            getClient(phone: phone)
        }
    }
    
    func getCook(phone: String) {
        let savedID = UserDefaults.standard.object(forKey: "id") as? Int ?? 0
        service.getCook(phone: phone) { cook in
            DispatchQueue.main.async {
                self.profile = ClientModel(id: savedID, name: self.configureName(name: cook.firstName), phone: self.configurePhone(phone: cook.phone))
                self.isLoading = false
            }
        }
    }
    
    func getClient(phone: String) {
        service.getClient(phone: phone) { client in
            DispatchQueue.main.async {
                self.profile = ClientModel(id: client.id, name: self.configureName(name: client.name ?? ""), phone: self.configurePhone(phone: client.phone ?? ""))
                self.isLoading = false
            }
        }
    }
    
    func getIsCook()-> Bool {
        return settingsManager.getIsCook()
    }
    
    func configureName(name: String)-> String {
        if name.isEmpty {
            return "Нет имени"
        } else {
            return name
        }
    }
    
    func configurePhone(phone: String)-> String {
        if phone.isEmpty {
            return "Нет телефона"
        } else {
            return "+7\(phone)"
        }
    }
}
