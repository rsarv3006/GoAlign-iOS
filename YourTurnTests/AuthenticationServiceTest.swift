//
//  AuthenticationService.swift
//  YourTurnTests
//
//  Created by rjs on 11/24/22.
//

import XCTest

final class AuthenticationServiceTest: XCTestCase {

    let sut = AuthenticationService.self

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCheckForStandardErrors() throws {
        for errorToTest in sut.AuthErrorHandling.errors {
            let errorString = sut.checkForStandardErrors(
                error: ServiceErrors.custom(
                    message: "garbage garbage \(errorToTest.keyword) garbage garbage"))
            XCTAssert(errorString == errorToTest.userFacingErrorString)
        }

        let errorString = sut.checkForStandardErrors(
            error: ServiceErrors.custom(
                message: "garbage garbage garbage garbage"))
        XCTAssert(errorString == sut.AuthErrorHandling.UserFacingErrorStrings.unknownError)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
