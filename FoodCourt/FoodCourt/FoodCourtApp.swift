//
//  FoodCourtApp.swift
//  FoodCourt
//
//  Created by Марк Киричко on 09.10.2024.
//

import SwiftUI
import Firebase
import FirebaseMessaging
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, _ in
            guard success else {
                return
            }
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
            print("Success in APNS registry")
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        checkToken(token: fcmToken!)
        print("Firebase registration token: \(String(describing: fcmToken!))")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                  willPresent notification: UNNotification) async
        -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo

        Messaging.messaging().appDidReceiveMessage(userInfo)
        handleMessages(data: userInfo)
        return [[.alert, .sound]]
    }
    
    func handleMessages(data: [AnyHashable: Any]) {
        if data["order"] != nil {
            print("yes")
            NotificationCenter.default.post(name: Notification.Name("order added"), object: nil)
        } else if data["data"] != nil {
            print("yes")
            NotificationCenter.default.post(name: Notification.Name("order changed"), object: nil)
        }
    }
    
    func checkToken(token: String) {
        let savedID = UserDefaults.standard.object(forKey: "id") as? Int ?? 0
        let isCook = UserDefaults.standard.object(forKey: "isCook") as? Bool ?? false
        let service = APIService()
        let fcm = FcmModel(fcm: token)
        if savedID == 0 {} else {
            service.updateToken(isCook: isCook, fcm: fcm, id: savedID) {}
        }
        UserDefaults.standard.setValue(token, forKey: "token")
    }
}

@main
struct FoodCourtApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let settingsManager = SettingsManager()
    
    var body: some Scene {
        WindowGroup {
            if settingsManager.getIsAuth() {
                if settingsManager.getIsCook() {
                    CookTabView()
                } else {
                    ClientTabView()
                }
            } else {
                RegistrationView()
            }
        }
    }
}
