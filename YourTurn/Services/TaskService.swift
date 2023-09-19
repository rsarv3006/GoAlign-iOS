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
        let url = try Networking.createUrl(endPoint: "v1/task/assignedToCurrentUser")
        
        let (data, response) = try await Networking.get(url: url)
        
        if let response = response as? HTTPURLResponse, response.statusCode == 200 {
            
            let taskItemsReturn = try GlobalDecoder.decode(TasksReturnModel.self, from: data)
            return taskItemsReturn.tasks
        } else {
            let serverError = try GlobalDecoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }
    }
    
    static func getTasksByTaskIds(taskIds: [UUID]) async throws -> TaskModelArray {
        let queryString = Networking.Helpers.createQueryString(items: taskIds.map({ uuid in
            return uuid.uuidString
        }))
        let url = try Networking.createUrl(endPoint: "v1/task?taskIds=\(queryString)")
        
        let (data, response) = try await Networking.get(url: url)
        
        if let response = response as? HTTPURLResponse, response.statusCode == 200 {
            let taskItems = try GlobalDecoder.decode(TaskModelArray.self, from: data)
            return taskItems
        } else {
            let serverError = try GlobalDecoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }
    }
    
    static func createTask(taskToCreate taskDto: CreateTaskDto) async throws -> TaskModel {
        
        let url = try Networking.createUrl(endPoint: "v1/task")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        let taskData = try encoder.encode(taskDto)
        
        let (data, response) = try await Networking.post(url: url, body: taskData)
        
        if let response = response as? HTTPURLResponse, response.statusCode == 201 {
            let taskCreateReturn = try GlobalDecoder.decode(TaskCreateReturnModel.self, from: data)
            return taskCreateReturn.task
        } else {
            let serverError = try GlobalDecoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }
        
    }
    
    static func markTaskComplete(taskEntryId: UUID) async throws {
        let url = try Networking.createUrl(endPoint: "v1/task-entry/markTaskEntryComplete/\(taskEntryId.uuidString)")
        
        let (data, response) = try await Networking.post(url: url)
        
        if let response = response as? HTTPURLResponse, response.statusCode == 201 {
            return
            
        } else {
            let serverError = try GlobalDecoder.decode(ServerErrorMessage.self, from: data)
            Logger.log(logLevel: .Verbose, name: Logger.Events.Task.markCompleteFailed, payload: ["error": serverError])
            throw ServiceErrors.custom(message: serverError.message)
        }
        
    }
    
    static func updateTask(updateTaskDto: UpdateTaskDto) async throws -> TaskModel {
        let url = try Networking.createUrl(endPoint: "v1/task/")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        let updateTaskData = try encoder.encode(updateTaskDto)
        
        let (data, response) = try await Networking.patch(url: url, body: updateTaskData)
        
        if let response = response as? HTTPURLResponse, response.statusCode == 201 {
            let taskModel = try GlobalDecoder.decode(TaskModel.self, from: data)
            return taskModel
        } else {
            let serverError = try GlobalDecoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }
    }
}

