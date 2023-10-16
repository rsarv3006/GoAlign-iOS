//
//  AppStateTests.swift
//  YourTurnTests
//
//  Created by Robert J. Sarvis Jr on 9/4/23.
//

import XCTest

final class AppStateTests: XCTestCase {
    // swiftlint:disable:next line_length
    let realToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVc2VyIjp7InVzZXJfaWQiOiI4YzBiNjhhYi0zMTUwLTRhODYtOTM4Zi1jMDlmODJjNGEzN2UiLCJ1c2VybmFtZSI6Im1lZXAiLCJlbWFpbCI6Im1lZXBAeWVldC5jb20iLCJpc19hY3RpdmUiOnRydWUsImlzX2VtYWlsX3ZlcmlmaWVkIjpmYWxzZSwiY3JlYXRlZF9hdCI6IjIwMjMtMDktMDRUMjE6NDI6MjguNTU5NTk1WiJ9LCJleHAiOjUyOTM5MjA4Mzh9.nBg6jWvyy6dzvndBxOE32XlhN0DBY87aOK1W1WME2pA"

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
   
    func testAppStateFlow() async throws {
        var state = AppState.getInstance()
        XCTAssertNil(state.currentUser)
        AppState.resetState()
        
        state = AppState.getInstance(accessToken: realToken, refreshToken: "")
        
        let currentUser = state.currentUser
        XCTAssertEqual(currentUser?.userId, "8c0b68ab-3150-4a86-938f-c09f82c4a37e")
        
        let checkUserNotOnState = AppState.getInstance().currentUser
        XCTAssertEqual(checkUserNotOnState?.userId, "8c0b68ab-3150-4a86-938f-c09f82c4a37e")
        
        let accessToken = try await state.getAccessToken()
        XCTAssertEqual(accessToken, realToken)
       
        let reinstantiated = try await AppState.getInstance().getAccessToken()
        XCTAssertEqual(reinstantiated, realToken)
        
        AppState.resetState()
    }
}
