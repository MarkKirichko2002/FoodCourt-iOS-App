//
//  FirebaseManager.swift
//  FoodCourt
//
//  Created by Марк Киричко on 21.11.2024.
//

import FirebaseRemoteConfig

final class FirebaseManager {
    
    func getConfig(key: String, completion: @escaping(Any)->Void) {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        remoteConfig.fetch { (status, error) in
            if status == .success {
                remoteConfig.activate()
                let fetchedValue = remoteConfig[key].numberValue
                completion(fetchedValue)
            }
        }
    }
    
    func getConfigArray(key: String, completion: @escaping([Dadata])->Void) {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        remoteConfig.fetch { (status, error) in
            if status == .success {
                remoteConfig.activate()
                let fetchedValue = remoteConfig[key].stringValue
                if let data = fetchedValue.data(using: .utf8) {
                    do {
                        let result = try JSONDecoder().decode([Dadata].self, from: data)
                        completion(result)
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}
