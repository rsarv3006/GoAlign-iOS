//
//  Task.swift
//  YourTurn
//
//  Created by rjs on 7/28/22.
//

import Foundation
import Combine

struct TaskService {
    static func getTasksByAssignedUserId() async throws -> TaskModelArray {
        let url = try Networking.createUrl(endPoint: "task/assignedToCurrentUser")
        
        let (data, response) = try await Networking.get(url: url)
        
        if let response = response as? HTTPURLResponse, response.statusCode == 200 {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = CUSTOM_ISO_DECODE
            
            let taskItemsReturn = try decoder.decode(TasksReturnModel.self, from: data)
            return taskItemsReturn.tasks
        } else {
            let decoder = JSONDecoder()
            let serverError = try decoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }
    }
    
    static func getTasksByTaskIds(taskIds: [String]) async throws -> TaskModelArray {
        let queryString = Networking.Helpers.createQueryString(items: taskIds)
        let url = try Networking.createUrl(endPoint: "task?taskIds=\(queryString)")
        
        let (data, response) = try await Networking.get(url: url)
        
        if let response = response as? HTTPURLResponse, response.statusCode == 200 {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = CUSTOM_ISO_DECODE
            
            let taskItems = try decoder.decode(TaskModelArray.self, from: data)
            return taskItems
        } else {
            let decoder = JSONDecoder()
            let serverError = try decoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }
    }
    
    static func createTask(taskToCreate taskDto: CreateTaskDto) async throws -> TaskModel {
        let url = try Networking.createUrl(endPoint: "task")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        let taskData = try encoder.encode(taskDto)
        
        let (data, response) = try await Networking.post(url: url, body: taskData)
        
        if let response = response as? HTTPURLResponse, response.statusCode == 201 {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = CUSTOM_ISO_DECODE
            
            let taskModel = try decoder.decode(TaskModel.self, from: data)
            return taskModel
        } else {
            let decoder = JSONDecoder()
            let serverError = try decoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }
        
    }
    
    static func markTaskComplete(taskId: String) async throws -> TaskModel {
        let url = try Networking.createUrl(endPoint: "task/markTaskComplete/\(taskId)")
        
        let (data, response) = try await Networking.post(url: url)
        
        if let response = response as? HTTPURLResponse, response.statusCode == 201 {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = CUSTOM_ISO_DECODE
            
            let taskModel = try decoder.decode(TaskModel.self, from: data)
            return taskModel
        } else {
            let decoder = JSONDecoder()
            let serverError = try decoder.decode(ServerErrorMessage.self, from: data)
            Logger.log(logLevel: .Verbose, name: Logger.Events.Task.markCompleteFailed, payload: ["error": serverError])
            throw ServiceErrors.custom(message: serverError.message)
        }
        
    }
    
    static func updateTask(updateTaskDto: UpdateTaskDto) async throws -> TaskModel {
        let url = try Networking.createUrl(endPoint: "task/")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        let updateTaskData = try encoder.encode(updateTaskDto)
        
        let (data, response) = try await Networking.patch(url: url, body: updateTaskData)
        
        if let response = response as? HTTPURLResponse, response.statusCode == 201 {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = CUSTOM_ISO_DECODE
            
            let taskModel = try decoder.decode(TaskModel.self, from: data)
            return taskModel
        } else {
            let decoder = JSONDecoder()
            let serverError = try decoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }
    }
}

