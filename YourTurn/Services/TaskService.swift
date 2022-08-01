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
        let url = URL(string: "http://localhost:4001/task/assignedToCurrentUser")
    
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
}

