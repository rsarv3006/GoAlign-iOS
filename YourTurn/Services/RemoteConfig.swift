//
//  RemoteConfig.swift
//  YourTurn
//
//  Created by rjs on 12/9/22.
//

import Foundation
import FirebaseRemoteConfig

func createFirebaseRemoteConfig() -> RemoteConfig {
    let remoteConfig = RemoteConfig.remoteConfig()
    let settings = RemoteConfigSettings()
    settings.minimumFetchInterval = 0
    remoteConfig.configSettings = settings

    remoteConfig.setDefaults(fromPlist: "remote_config_defaults")

    remoteConfig.fetch { (status, error) -> Void in
        if status == .success {
            print("Config fetched!")
            remoteConfig.activate { _, _ in

            }
        } else {
            print("Config not fetched")
            print("Error: \(error?.localizedDescription ?? "No error available.")")
        }
    }

    return remoteConfig
}

let remoteConfig = createFirebaseRemoteConfig()
