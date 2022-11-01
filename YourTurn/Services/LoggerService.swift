//
//  LoggerService.swift
//  YourTurn
//
//  Created by rjs on 8/15/22.
//

import Foundation
import FirebaseAnalytics

enum LogLevel: String {
    case Verbose = "verbose"
    case Prod = "prod"
}

struct Logger {
    static func log(logLevel: LogLevel, name: String, payload: Dictionary<String, Any>) {
        let LOG_LEVEL = getLogLevel()
        let IS_ANALYTICS_ENABLED = getAnalyticsEnabled()
        let shouldPrintLogs = getPrintLogs()
        
        guard logLevelMatches(logLevel, setLogLevel: LOG_LEVEL) else { return }
        
        let logString = "\(Date.now.ISO8601Format()) - \(logLevel.rawValue) - \(name) - \(payload)"
        
        if shouldPrintLogs {
            print(logString)
        }
        
        var mutablePayload = payload
        mutablePayload["originator"] = "iosMobile"
        
        if IS_ANALYTICS_ENABLED {
            Analytics.logEvent(name, parameters: mutablePayload)
        }
    }
    
    private static func logLevelMatches(_ logLevel : LogLevel, setLogLevel LOG_LEVEL: LogLevel) -> Bool {
        if logLevel == LOG_LEVEL {
            return true
        } else if logLevel == .Prod && LOG_LEVEL == .Verbose {
            return true
        }
        
        return false
    }
    
    private static func getLogLevel() -> LogLevel {
        if LogLevel.Prod.rawValue == Bundle.main.object(forInfoDictionaryKey: "LOG_LEVEL") as? String {
            return .Prod
        }
        
        return .Verbose
    }
    
    private static func getAnalyticsEnabled() -> Bool {
        if let isAnalyticsEnabled = Bundle.main.object(forInfoDictionaryKey: "LOG_TO_ANALYTICS") as? Bool {
            return isAnalyticsEnabled
        }
        
        return true
    }
    
    private static func getPrintLogs() -> Bool {
        if let shouldPrintLogs = Bundle.main.object(forInfoDictionaryKey: "PRINT_LOGS") as? Bool {
            return shouldPrintLogs
        }
        
        return true
    }
    
    struct Events {
        struct User {
            static let fetchFailed = "user.fetch.fail"
            static let createFailed = "user.create.fail"
        }
        
        struct Auth {
            static let signOutFailed = "auth.signout.fail"
            static let tokenFetchFailed = "auth.token.fetch.fail"
            static let signInValidationFailed = "auth.signin.validation.fail"
            static let signUpValidationFailed = "auth.signup.validation.fail"
        }
        
        struct Team {
            static let teamCreated = "team.create.success"
            static let teamCreateFailed = "team.create.fail"
            static let fetchFailed = "team.fetch.fail"
            
            struct Invite {
                static let fetchFailed = "team.invite.fetch.fail"
            }
        }
        
        struct Task {
            static let creationFailed = "task.create.fail"
            static let creationValidationFailed = "task.create.validation.fail"
            static let markCompleteFailed = "task.mark.complete.fail"
        }
        
        struct Form {
            struct Field {
                static let validationFailed = "form.field.validation.fail"
            }
        }
        
        struct Networking {
            static let callFailed = "networking.call.failed"
        }
    }
}
