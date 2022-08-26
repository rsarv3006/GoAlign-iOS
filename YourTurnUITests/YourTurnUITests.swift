//
//  YourTurnUITests.swift
//  YourTurnUITests
//
//  Created by rjs on 6/20/22.
//

import XCTest

class YourTurnUITests: XCTestCase {
    var app: XCUIApplication?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app = XCUIApplication()
        guard let app = app else {
            return
        }

        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func testLoginFlow() throws {
        guard let app = app else { return }
        let credentials = loadTestCredentialsJSON(fileName: "credentials")
        app.buttons["Already have an Account?  Click here to Sign In!"].tap()
        
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery/*@START_MENU_TOKEN@*/.cells.textFields["Email Address"]/*[[".cells.textFields[\"Email Address\"]",".textFields[\"Email Address\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()
        collectionViewsQuery.cells.textFields["Email Address"].typeText(credentials!.username)
        
        collectionViewsQuery/*@START_MENU_TOKEN@*/.secureTextFields["Password"]/*[[".cells.secureTextFields[\"Password\"]",".secureTextFields[\"Password\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.secureTextFields["Password"]/*[[".cells.secureTextFields[\"Password\"]",".secureTextFields[\"Password\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.typeText(credentials!.password)
        
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Sign In!"]/*[[".cells.buttons[\"Sign In!\"]",".buttons[\"Sign In!\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.staticTexts["My Tasks"].tap()
        
    }
    
    func testTeamCreateFlow() throws {
        guard let app = app else { return }
        
        app.buttons["duplicate"].tap()
        let teamNameField = app.textFields["Team Name"]
        teamNameField.tap()
        teamNameField.typeText("TestTeam")
        
        app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Create"].tap()
        app.staticTexts["My Tasks"].tap()
        
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
