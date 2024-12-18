//
//  CreateCookViewModel.swift
//  FoodCourt
//
//  Created by Марк Киричко on 16.11.2024.
//

import Foundation

final class CreateCookViewModel: ObservableObject {
    
    @Published var key = ""
    @Published var fio = ""
    @Published var phone = ""
    @Published var alert = false
    @Published var isChanged = false
    
    var alertText = ""
    
    // MARK: - сервисы
    private let service = APIService()
    private let settingsManager = SettingsManager()
    
    func saveCook() {
        if key == "123" {
            if fio.components(separatedBy: " ").count < 3 {
                alertText = "Введите полное ФИО!"
                DispatchQueue.main.async {
                    self.alert.toggle()
                }
            } else if phone.isEmpty {
                alertText = "Введите ваш номер телефона!"
                DispatchQueue.main.async {
                    self.alert.toggle()
                }
            } else {
                addCook()
            }
        } else {
            alertText = "Введите правильный код!"
            DispatchQueue.main.async {
                self.alert.toggle()
            }
        }
    }
    
    func addCook() {
        let token = settingsManager.getToken()
        let correctNumber = String(phone.dropFirst())
        let cook = Cook(firstName: fio.components(separatedBy: " ")[1], lastName: fio.components(separatedBy: " ")[0], fatherName: fio.components(separatedBy: " ")[2], fcmToken: token, phone: correctNumber)
        service.createCook(cook: cook) { model in
            self.saveData(cook: model)
            DispatchQueue.main.async {
                self.isChanged.toggle()
            }
        }
    }
    
    func convertText()-> String {
        return phone.convertText()
    }
    
    func saveData(cook: CookModel) {
        UserDefaults.standard.set(cook.id, forKey: "id")
        UserDefaults.standard.set(cook.phone, forKey: "phone")
        UserDefaults.standard.set(true, forKey: "isCook")
        UserDefaults.standard.set(true, forKey: "isAuth")
    }
}
