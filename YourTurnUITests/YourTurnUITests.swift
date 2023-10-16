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
        // swiftlint:disable:next line_length
        collectionViewsQuery/*@START_MENU_TOKEN@*/.cells.textFields["Email Address"]/*[[".cells.textFields[\"Email Address\"]",".textFields[\"Email Address\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()
        collectionViewsQuery.cells.textFields["Email Address"].typeText(credentials!.username)

        // swiftlint:disable:next line_length
        collectionViewsQuery/*@START_MENU_TOKEN@*/.secureTextFields["Password"]/*[[".cells.secureTextFields[\"Password\"]",".secureTextFields[\"Password\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        collectionViewsQuery
        // swiftlint:disable:next line_length
        /*@START_MENU_TOKEN@*/.secureTextFields["Password"]/*[[".cells.secureTextFields[\"Password\"]",".secureTextFields[\"Password\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
            .typeText(credentials!.password)

        // swiftlint:disable:next line_length
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Sign In!"]/*[[".cells.buttons[\"Sign In!\"]",".buttons[\"Sign In!\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.staticTexts["My Tasks"].tap()

    }

    func testTeamCreateFlow() throws {
        guard let app = app else { return }

        app.buttons["duplicate"].tap()
        let teamNameField = app.textFields["Team Name"]
        teamNameField.tap()
        teamNameField.typeText("TestTeam")

        // swiftlint:disable:next line_length
        app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Create Team"].tap()
        app.staticTexts["My Tasks"].tap()

    }

    func testGroupStatsTabs() throws {
        guard let app = app else { return }

        // swiftlint:disable:next line_length
        app.tables/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier: "GroupWithNoName").element/*[[".cells.containing(.staticText, identifier:\"Tasks: 6\").element",".cells.containing(.staticText, identifier:\"GroupWithNoName\").element"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.tabBars["Tab Bar"].buttons["Stats"].tap()
        app.staticTexts["Team Stats"].tap()
    }

    func testDrawerTeamInvites() throws {
        guard let app = app else { return }
        app.buttons["drag"].tap()
        // swiftlint:disable:next line_length
        app/*@START_MENU_TOKEN@*/.staticTexts["Invites"]/*[[".buttons[\"Invites\"].staticTexts[\"Invites\"]",".staticTexts[\"Invites\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Team Invites"].staticTexts["Team Invites"].tap()
    }

    func testDrawerSettingsDelete() throws {
        guard let app = app else { return }
        app.buttons["drag"].tap()
        app.staticTexts["Settings"]
            .tap()

        // swiftlint:disable:next line_length
        app.tables/*@START_MENU_TOKEN@*/.buttons["Delete Account"]/*[[".cells.buttons[\"Delete Account\"]",".buttons[\"Delete Account\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

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
