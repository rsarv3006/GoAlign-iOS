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
    static func log(logLevel: LogLevel, message: String) {
        let LOG_LEVEL = getLogLevel()
        let IS_ANALYTICS_ENABLED = getAnalyticsEnabled()
        let shouldPrintLogs = getPrintLogs()
        
        guard logLevelMatches(logLevel, setLogLevel: LOG_LEVEL) else { return }
        
        let logString = "\(Date.now.ISO8601Format()) - \(logLevel.rawValue) - \(message)"
        
        if shouldPrintLogs {
            print(logString)
        }
        
        
        if IS_ANALYTICS_ENABLED {
            Analytics.logEvent(logString, parameters: [:])
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
}
