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
        guard let url = Networking.createUrl(endPoint: "task/assignedToCurrentUser") else {
            throw ServiceErrors.unknownUrl
        }
        
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
        guard let url = Networking.createUrl(endPoint: "task") else {
            throw ServiceErrors.unknownUrl
        }
        
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
        guard let url = Networking.createUrl(endPoint: "task/markTaskComplete/\(taskId)") else {
            throw ServiceErrors.unknownUrl
        }
        
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
}

