//
//  IntervalObject.swift
//  YourTurn
//
//  Created by rjs on 7/28/22.
//

import Foundation

enum IntervalVariant: String {
    case minute = "minute(s)"
    case hour = "hour(s)"
    case day = "day(s)"
    case week = "week(s)"
    case month = "month(s)"
    case year = "year(s)"
}

let INTERVALS_ARRAY = [IntervalVariant.minute, IntervalVariant.hour, IntervalVariant.day, IntervalVariant.week, IntervalVariant.month, IntervalVariant.year]

class IntervalObject: Codable, Equatable {
    static func == (lhs: IntervalObject, rhs: IntervalObject) -> Bool {
        if lhs.intervalNumber == rhs.intervalNumber && lhs.intervalType == rhs.intervalType {
            return true
        }
        
        return false
    }
    
    var intervalNumber: Int = 1
    var intervalType: IntervalVariant = .day
    
    init(_ intervalNumber: Int, _ intervalType: IntervalVariant){
        self.intervalNumber = intervalNumber
        self.intervalType = intervalType
    }
    
    func toString() -> String {
        return "\(intervalNumber) - \(intervalType.rawValue)"
    }
    
    private enum CodingKeys: String, CodingKey {
        case intervalNumber
        case intervalType
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.intervalNumber = try container.decode(Int.self, forKey: .intervalNumber)
        let typeString = try container.decode(String.self, forKey: .intervalType)
        self.intervalType = IntervalVariant(rawValue: typeString)!
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(intervalNumber, forKey: .intervalNumber)
        try container.encode(intervalType.rawValue, forKey: .intervalType)
    }
}
