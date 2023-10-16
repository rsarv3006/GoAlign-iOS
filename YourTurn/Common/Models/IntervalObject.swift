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
        if lhs.intervalCount == rhs.intervalCount && lhs.intervalUnit == rhs.intervalUnit {
            return true
        }

        return false
    }

    var intervalCount: Int = 1
    var intervalUnit: IntervalVariant = .day

    init(_ intervalCount: Int, _ intervalUnit: IntervalVariant){
        self.intervalCount = intervalCount
        self.intervalUnit = intervalUnit
    }

    func toString() -> String {
        return "\(intervalCount) - \(intervalUnit.rawValue)"
    }
    
    private enum CodingKeys: String, CodingKey {
        case intervalCount
        case intervalUnit
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.intervalCount = try container.decode(Int.self, forKey: .intervalCount)
        let typeString = try container.decode(String.self, forKey: .intervalUnit)
        self.intervalUnit = IntervalVariant(rawValue: typeString)!
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(intervalCount, forKey: .intervalCount)
        try container.encode(intervalUnit.rawValue, forKey: .intervalUnit)
    }
}
