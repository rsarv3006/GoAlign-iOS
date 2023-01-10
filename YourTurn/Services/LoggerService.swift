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
        
        if LogLevel.Prod.rawValue == remoteConfig.configValue(forKey: "LOG_LEVEL").stringValue {
            return .Prod
        }
        
        return .Verbose
    }
    
    private static func getAnalyticsEnabled() -> Bool {
        
        return remoteConfig.configValue(forKey: "LOG_TO_ANALYTICS").boolValue
    }
    
    private static func getPrintLogs() -> Bool {
        return remoteConfig.configValue(forKey: "PRINT_LOGS").boolValue
    }
    
    struct Events {
        struct User {
            static let fetchFailed = "user_fetch_fail"
            static let createFailed = "user_create_fail"
            static let deleteAttempt = "user_delete_attempt"
            static let userRequestedLogout = "user_request_logout"
        }
        
        struct Auth {
            static let signOutFailed = "auth_signout_fail"
            static let tokenFetchFailed = "auth_token_fetch_fail"
            static let signInValidationFailed = "auth_signin_validation_fail"
            static let signUpValidationFailed = "auth_signup_validation_fail"
            static let signInFailed = "auth_signin_fail"
        }
        
        struct Team {
            static let teamCreated = "team_create_success"
            static let teamCreateFailed = "team_create_fail"
            static let fetchFailed = "team_fetch_fail"
            static let deleteAttempt = "team_delete_attempt"
            static let leaveAttempt = "team_leave_attempt"
            static let leaveSuccess = "team_leave_success"
            
            struct Invite {
                static let fetchFailed = "team_invite_fetch_fail"
                static let createFailed = "team_invite_create_fail"
                static let declineFailed = "team_invite_decline_fail"
                static let acceptFailed = "team_invite_accept_fail"
            }
            
            struct Stats {
                static let fetchFailed = "team_stats_fetch_fail"
            }
        }
        
        struct Task {
            static let creationFailed = "task_create_fail"
            static let creationValidationFailed = "task_create_validation_fail"
            static let markCompleteFailed = "task_mark_complete_fail"
            static let updateValidationFailed = "task_update_validation_fail"
        }
        
        struct Form {
            struct Field {
                static let validationFailed = "form_field_validation_fail"
            }
        }
        
        struct Networking {
            static let callFailed = "networking_call_failed"
        }
    }
}
