//
//  API.swift
//  YourTurn
//
//  Created by rjs on 7/28/22.
//

import Foundation
import Combine

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

struct Networking {
    private static func apiCall(httpMethod: HttpMethod, url: URL, body: Data? = nil, completion: @escaping((Data?, URLResponse?, Error?) -> Void)) {
        AuthenticationService.getToken { token, error in
            guard let token = token else {
                Logger.log(logLevel: .Prod, message: "Something is wrong with SignIn form: \(String(describing: error))")
                return
            }
            var request = URLRequest(url: url)

            request.httpMethod = httpMethod.rawValue
            if let body = body {
                request.httpBody = body
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue(token, forHTTPHeaderField: "Authorization")

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                completion(data, response, error)
            }

            task.resume()
        }
    }
    
    static func get(url: URL, body: Data? = nil, completion: @escaping((Data?, URLResponse?, Error?) -> Void)) {
        self.apiCall(httpMethod: .get, url: url, body: body) { data, response, error in
            completion(data, response, error)
        }
    }
    
    static func post(url: URL, body: Data? = nil, completion: @escaping((Data?, URLResponse?, Error?) -> Void)) {
        self.apiCall(httpMethod: .post, url: url, body: body) { data, response, error in
            completion(data, response, error)
        }
    }
    
    static func delete(url: URL, body: Data? = nil, completion: @escaping((Data?, URLResponse?, Error?) -> Void)) {
        self.apiCall(httpMethod: .delete, url: url) { data, response, error in
            completion(data, response, error)
        }
    }
    
    static func createUrl(endPoint: String) -> URL? {
        guard let baseUrl = Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String else { return nil }
        
        let url = URL(string: "\(baseUrl)\(endPoint)")
    
        guard let url = url else { return nil }
        
        return url
    }
}
