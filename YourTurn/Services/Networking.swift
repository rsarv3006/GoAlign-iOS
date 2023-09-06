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
    case put = "PUT"
    case patch = "PATCH"
}

struct Networking {
    private static let baseUrlString: String = "http://localhost:3000/api/"

    private static func apiCall(httpMethod: HttpMethod, url: URL, body: Data? = nil) async throws -> (Data, URLResponse) {
        let token = try await AppState.getInstance().getAccessToken()
        print("token: \(token)")

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        if let body = body {
            request.httpBody = body
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let response = try await URLSession.shared.data(for: request)

        return response
    }

    static func noAuthApiCall(httpMethod: HttpMethod, url: URL, body: Data? = nil) async throws -> (Data, URLResponse) {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        if let body = body {
            request.httpBody = body
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        request.addValue("application/json", forHTTPHeaderField: "Accept")
        // TODO - implement anon token
//        request.setValue("Bearer \(anonToken)", forHTTPHeaderField: "Authorization")

        let response = try await URLSession.shared.data(for: request)

        return response
    }

    static func get(url: URL, body: Data? = nil, noAuth: Bool = false) async throws -> (Data, URLResponse) {
        if noAuth == true {
            return try await noAuthApiCall(httpMethod: .get, url: url, body: body)
        } else {
            return try await apiCall(httpMethod: .get, url: url, body: body)
        }

    }

    static func post(url: URL, body: Data? = nil, noAuth: Bool = false) async throws -> (Data, URLResponse) {
        if noAuth == true {
            return try await noAuthApiCall(httpMethod: .post, url: url, body: body)
        } else {
            return try await apiCall(httpMethod: .post, url: url, body: body)
        }
    }

    static func put(url: URL, body: Data? = nil, noAuth: Bool = false) async throws -> (Data, URLResponse) {
        if noAuth == true {
            return try await noAuthApiCall(httpMethod: .put, url: url, body: body)
        } else {
            return try await apiCall(httpMethod: .put, url: url, body: body)
        }
    }

    static func patch(url: URL, body: Data? = nil, noAuth: Bool = false) async throws -> (Data, URLResponse) {
        if noAuth == true {
            return try await noAuthApiCall(httpMethod: .patch, url: url, body: body)
        } else {
            return try await apiCall(httpMethod: .patch, url: url, body: body)
        }
    }

    static func delete(url: URL, body: Data? = nil, noAuth: Bool = false) async throws -> (Data, URLResponse) {
        if noAuth == true {
            return try await noAuthApiCall(httpMethod: .delete, url: url, body: body)
        } else {
            return try await apiCall(httpMethod: .delete, url: url, body: body)
        }
    }

    static func createUrl(endPoint: String) throws -> URL {
        let url = URL(string: "\(self.baseUrlString)\(endPoint)")

        guard let url = url else {
            throw ServiceErrors.unknownUrl
        }

        return url
    }

    struct Helpers {
        static func createQueryString(items: [String]) -> String {
            var returnString = ""
            for item in items {
                returnString += "\(item),"
            }

            if returnString.last == "," {
                _ = returnString.popLast()
            }

            return returnString
        }
    }
}

