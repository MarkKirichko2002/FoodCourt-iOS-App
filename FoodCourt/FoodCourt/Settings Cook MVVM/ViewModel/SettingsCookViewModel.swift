//
//  SettingsCookViewModel.swift
//  FoodCourt
//
//  Created by Марк Киричко on 20.11.2024.
//

import Foundation

final class SettingsCookViewModel: ObservableObject {
    
    @Published var cook = Cook(firstName: "", lastName: "", fatherName: "", fcmToken: "", phone: "")
    @Published var isDeleted = false
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
    let service = APIService()
    
    init() {
        setUpData()
    }
    
    func setUpData() {
        let phone = settingsManager.getPhone()
        let token = settingsManager.getToken()
        cook.fcmToken = token
        service.getCook(phone: phone) { cook in
            DispatchQueue.main.async {
                self.cook = Cook(firstName: cook.firstName, lastName: cook.lastName, fatherName: cook.fatherName, fcmToken: phone, phone: cook.phone)
            }
        }
    }
    
    func handleChanges(completion: @escaping()->Void) {
        let savedID = UserDefaults.standard.object(forKey: "id") as? Int ?? 0
        let cook = CookModel(id: savedID, firstName: cook.firstName, lastName: cook.lastName, fatherName: cook.fatherName, phone: cook.phone)
        service.changeCook(cook: cook) {completion()}
    }
    
    func deleteCook() {
        service.deleteCook {
            self.saveData()
            DispatchQueue.main.async {
                self.isDeleted.toggle()
            }
        }
    }
    
    func saveData() {
        UserDefaults.standard.set(0, forKey: "id")
        UserDefaults.standard.set(false, forKey: "isAuth")
        UserDefaults.standard.set(false, forKey: "isCook")
    }
    
    func convertText()-> String {
        return cook.phone.convertText()
    }
}
