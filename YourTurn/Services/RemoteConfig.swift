//
//  RemoteConfig.swift
//  YourTurn
//
//  Created by rjs on 12/9/22.
//

import Foundation
import FirebaseRemoteConfig

var isUnderMaintenance = false

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

    isUnderMaintenance = remoteConfig.configValue(forKey: "IS_UNDER_MAINTENANCE").boolValue

    remoteConfig.addOnConfigUpdateListener { configUpdate, error in
      guard configUpdate != nil, error == nil else {
          Logger.log(
            logLevel: .prod,
            name: "config-issue",
            payload: ["error": String(describing: error?.localizedDescription)])
          return
      }

      remoteConfig.activate { _, error in
          guard error == nil else {
              Logger.log(
                logLevel: .prod,
                name: "config-issue",
                payload: ["error": String(describing: error?.localizedDescription)])
          return }
        DispatchQueue.main.async {
            isUnderMaintenance = remoteConfig.configValue(forKey: "IS_UNDER_MAINTENANCE").boolValue
        }
      }
    }

    return remoteConfig
}

let remoteConfig = createFirebaseRemoteConfig()
