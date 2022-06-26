//
//  Network.swift
//  YourTurn
//
//  Created by rjs on 6/21/22.
//

import Foundation
import Apollo

class Network {
  static let shared = Network()

  private(set) lazy var apollo = ApolloClient(url: URL(string: "http://localhost:3000/graphql")!)
}
