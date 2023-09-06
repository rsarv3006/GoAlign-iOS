//
//  NetworkingTests.swift
//  YourTurnTests
//
//  Created by rjs on 11/24/22.
//

import XCTest

final class NetworkingTests: XCTestCase {

    let sut = Networking.self
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testQueryStringBuilder() throws {
        let testStringArr = ["test", "other", "test"]
        let queryString = sut.Helpers.createQueryString(items: testStringArr)
        XCTAssert(queryString == "test,other,test")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
