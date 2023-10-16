//
//  CredsModel.swift
//  YourTurnUITests
//
//  Created by rjs on 8/25/22.
//

import Foundation

struct TestCredentials: Codable {
    let username: String
    let password: String
}

func loadTestCredentialsJSON(fileName: String) -> TestCredentials? {
   let decoder = JSONDecoder()
   guard
        let url = Bundle(for: YourTurnUITests.self).url(forResource: fileName, withExtension: "json"),
        let data = try? Data(contentsOf: url),
        let person = try? decoder.decode(TestCredentials.self, from: data)
   else {
        return nil
   }

   return person
}
