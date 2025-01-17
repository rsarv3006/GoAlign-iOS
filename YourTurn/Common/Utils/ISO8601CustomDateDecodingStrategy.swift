//
//  ISO8601CustomDateDecodingStrategy.swift
//  YourTurn
//
//  Created by rjs on 8/21/22.
//

import Foundation

enum DateError: String, Error {
    case invalidDate
}

let CUSTOMISODECODE: JSONDecoder.DateDecodingStrategy = .custom({ (decoder) -> Date in
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)

    let container = try decoder.singleValueContainer()
    let dateStr = try container.decode(String.self)

    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
    if let date = formatter.date(from: dateStr) {
        return date
    }
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
    if let date = formatter.date(from: dateStr) {
        return date
    }
    throw DateError.invalidDate
})

func decodeISO8601DateFromString(dateString: String) throws -> Date {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)

    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
    if let date = formatter.date(from: dateString) {
        return date
    }

    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
    if let date = formatter.date(from: dateString) {
        return date
    }
    throw DateError.invalidDate
}

func createGlobalDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = CUSTOMISODECODE
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
}

let globalDecoder = createGlobalDecoder()
