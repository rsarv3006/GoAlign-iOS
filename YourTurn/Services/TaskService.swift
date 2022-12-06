//
//  Task.swift
//  YourTurn
//
//  Created by rjs on 7/28/22.
//

import Foundation
import Combine

struct TaskService {
    static func getTasksByAssignedUserId(completionHandler: @escaping((TaskModelArray?, Error?) -> Void)) {
        guard let url = Networking.createUrl(endPoint: "task/assignedToCurrentUser") else {
            completionHandler(nil, ServiceErrors.unknownUrl)
            return
        }
        
        Networking.get(url: url) { data, response, error in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = CUSTOM_ISO_DECODE
                    
                    let taskItems = try decoder.decode(TaskModelArray.self, from: data)
                    completionHandler(taskItems, nil)
                } catch {
                    completionHandler(nil, error)
                    return
                }
            }
        }
    }
    
    static func createTask(taskToCreate taskDto: CreateTaskDto, completionHandler: @escaping((TaskModel?, Error?) -> Void)) {
        guard let url = Networking.createUrl(endPoint: "task") else {
            completionHandler(nil, ServiceErrors.unknownUrl)
            return
        }
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        let taskData = try? encoder.encode(taskDto)
        
        guard let taskData = taskData else {
            completionHandler(nil, ServiceErrors.dataSerializationFailed)
            return
        }
        
        Networking.post(url: url, body: taskData) { data, response, error in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
                
            if let data = data, let response = response as? HTTPURLResponse {
                do {
                    if response.statusCode == 500 {
                        throw ServiceErrors.server500(message: (String(data: data, encoding: String.Encoding.utf8) ?? "Something went wrong"))
                    }
                    
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = CUSTOM_ISO_DECODE
                    
                    let taskModel = try decoder.decode(TaskModel.self, from: data)
                    completionHandler(taskModel, nil)
                } catch {
                    Logger.log(logLevel: .Prod, name: Logger.Events.Task.creationFailed, payload: ["error": error])
                    completionHandler(nil, error)
                }
            }
        }
    }
    
    static func markTaskComplete(taskId: String, completionHandler: @escaping((TaskModel?, Error?) -> Void)) {
        guard let url = Networking.createUrl(endPoint: "task/markTaskComplete/\(taskId)") else {
            completionHandler(nil, ServiceErrors.unknownUrl)
            return
        }
        
        Networking.post(url: url) { data, response, error in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            if let data = data, let response = response as? HTTPURLResponse {
                do {
                    if response.statusCode == 500 {
                        throw ServiceErrors.server500(message: (String(data: data, encoding: String.Encoding.utf8) ?? "Something went wrong"))
                    }
                    
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = CUSTOM_ISO_DECODE
                    
                    let taskModel = try decoder.decode(TaskModel.self, from: data)
                    completionHandler(taskModel, nil)
                } catch {
                    Logger.log(logLevel: .Verbose, name: Logger.Events.Task.markCompleteFailed, payload: ["error": error])
                    completionHandler(nil, error)
                }
            }
            
        }
    }
}

