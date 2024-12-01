//
//  FirebaseManager.swift
//  FoodCourt
//
//  Created by Марк Киричко on 21.11.2024.
//

import FirebaseRemoteConfig

final class FirebaseManager {
    
    func getConfig(key: String, completion: @escaping(String)->Void) {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        remoteConfig.fetch { (status, error) in
            if status == .success {
                remoteConfig.activate()
                let fetchedValue = remoteConfig[key].stringValue
                completion(fetchedValue)
            }
        }
    }
}

