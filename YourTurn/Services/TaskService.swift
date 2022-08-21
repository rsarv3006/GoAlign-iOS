//
//  Task.swift
//  YourTurn
//
//  Created by rjs on 7/28/22.
//

import Foundation
import Combine

enum TaskError: Error {
    case custom(message: String)
}

struct TaskService {
    static func getTasksByAssignedUserId(completionHandler: @escaping((TaskModelArray?, Error?) -> Void)) {
        guard let baseUrl = Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String else {
            completionHandler(nil, TaskError.custom(message: "API_URL is malformed."))
            return
        }
        
        let url = URL(string: "\(baseUrl)task/assignedToCurrentUser")
    
        guard let url = url else {
            completionHandler(nil, TaskError.custom(message: "Bad URL"))
            return
        }
        
        Networking.get(url: url) { data, response, error in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            if let data = data {
                do {
                    let taskItems = try JSONDecoder().decode(TaskModelArray.self, from: data)
                    completionHandler(taskItems, nil)
                } catch {
                    completionHandler(nil, error)
                    return
                }
            }
        }
    }
    
    static func createTask(taskToCreate taskDto: CreateTaskDto, completionHandler: @escaping((TaskModel?, Error?) -> Void)) {
        guard let baseUrl = Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String else {
            completionHandler(nil, TaskError.custom(message: "API_URL is malformed."))
            return
        }
        
        let url = URL(string: "\(baseUrl)task")
        
        guard let url = url else {
            completionHandler(nil, TaskError.custom(message: "Create Task - Bad Url"))
            return
        }
        
        let taskData = try? JSONEncoder().encode(taskDto)
        
        print(taskDto)
        
        print("Garbled nonsense from eons past")
        print(taskData)
        guard let taskData = taskData else {
            completionHandler(nil, UserError.custom(message: "Serialization of Create Task DTO failed"))
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
                        throw TaskError.custom(message: (String(data: data, encoding: String.Encoding.utf8) ?? "Something went wrong"))
                    }
                    print("HI")
                    print(data)
                    let taskModel = try JSONDecoder().decode(TaskModel.self, from: data)
                    completionHandler(taskModel, nil)
                } catch {
                    Logger.log(logLevel: .Verbose, message: "FAILED to create task: \(error)")
                    completionHandler(nil, error)
                }
            }
        }
    }
}

