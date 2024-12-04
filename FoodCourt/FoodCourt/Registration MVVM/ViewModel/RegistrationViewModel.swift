//
//  RegistrationViewModel.swift
//  FoodCourt
//
//  Created by Марк Киричко on 21.11.2024.
//

import FirebaseMessaging

final class RegistrationViewModel: ObservableObject {
    
    @Published var isPresented = false
    @Published var client = Client(name: "", phone: "", fcmToken: "")
    @Published var isAuth = false
    @Published var alert = false
    
    var alertText = ""
    
    // MARK: - сервисы
    private let service = APIService()
    private let settingsManager = SettingsManager()
    
    func handleRegistration() {
        if client.name.isEmpty && client.phone.isEmpty {
            alertText = "Введите имя и телефон!"
            alert.toggle()
        } else if client.name.isEmpty {
            alertText = "Введите ваше имя!"
            alert.toggle()
        } else if client.phone.isEmpty {
            alertText = "Введите ваш телефон!"
            alert.toggle()
        } else {
            addUser()
        }
    }
    
    func addUser() {
        let isCook = settingsManager.getIsCook()
        if let fcmToken = Messaging.messaging().fcmToken {
            print("TOKEEEN: \(fcmToken)")
            let fcm = FcmModel(fcm: fcmToken)
            client.fcmToken = fcmToken
            client.phone = String(client.phone.dropFirst())
            service.addUser(client: client) { model in
                self.service.updateToken(isCook: isCook, fcm: fcm, id: model.id ?? 0) {}
                self.saveData(client: model)
                DispatchQueue.main.async {
                    self.isAuth = true
                }
            }
        }
    }
    
    func convertText()-> String {
        return client.phone.convertText()
    }
    
    func saveData(client: ClientModel) {
        UserDefaults.standard.set(client.id, forKey: "id")
        UserDefaults.standard.set(client.phone, forKey: "phone")
        UserDefaults.standard.set(true, forKey: "isAuth")
    }
}
