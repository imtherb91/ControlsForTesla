//
//  LoginTests.swift
//  Controls for Tesla PurchasesTests
//
//  Created by Luke Allen on 3/5/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import XCTest

class LoginTests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUp() {
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
        logout()
    }

    override func tearDown() {
        testLogout()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLogin() {
        app.buttons["Log in"].tap()
        sleep(2)
        XCTAssertTrue(app.navigationBars["Controls for Tesla"].staticTexts["Controls for Tesla"].exists)
    }
    
    func testLogout() {
        logout()
    }
    
    func testVehiclesList() {
        testLogin()
        sleep(2)
        XCTAssertTrue(app.tables/*@START_MENU_TOKEN@*/.buttons["Speedy Boi\nModel 3"]/*[[".cells.buttons[\"Speedy Boi\\nModel 3\"]",".buttons[\"Speedy Boi\\nModel 3\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
    }
    
    func testVehicleView() {
        testVehiclesList()
        app.tables/*@START_MENU_TOKEN@*/.buttons["Speedy Boi\nModel 3"]/*[[".cells.buttons[\"Speedy Boi\\nModel 3\"]",".buttons[\"Speedy Boi\\nModel 3\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        sleep(2)
        let vehicleViewNav = app.navigationBars["Speedy Boi"].staticTexts["Speedy Boi"]
        XCTAssertTrue(vehicleViewNav.exists)
    }
    
    func testVehicleViewItems() {
        testVehicleView()
        sleep(3)
        
        let tablesQuery = app.tables
        XCTAssertTrue(app.navigationBars["Speedy Boi"].buttons["arrow.clockwise"].exists)
        XCTAssertTrue(tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Interior"]/*[[".cells.staticTexts[\"Interior\"]",".staticTexts[\"Interior\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
        XCTAssertTrue(tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Outside"]/*[[".cells.staticTexts[\"Outside\"]",".staticTexts[\"Outside\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
        XCTAssertTrue(tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Climate setting"]/*[[".cells.staticTexts[\"Climate setting\"]",".staticTexts[\"Climate setting\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
        XCTAssertTrue(tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["71.6º"]/*[[".cells.staticTexts[\"71.6º\"]",".staticTexts[\"71.6º\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
        XCTAssertTrue(tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["77.0º"]/*[[".cells.staticTexts[\"77.0º\"]",".staticTexts[\"77.0º\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
        XCTAssertTrue(tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["68.0º"]/*[[".cells.staticTexts[\"68.0º\"]",".staticTexts[\"68.0º\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
        XCTAssertTrue(tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["2018"]/*[[".cells.staticTexts[\"2018\"]",".staticTexts[\"2018\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
        XCTAssertTrue(tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Model 3"]/*[[".cells.staticTexts[\"Model 3\"]",".staticTexts[\"Model 3\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
        XCTAssertTrue(tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["79%"]/*[[".cells.staticTexts[\"79%\"]",".staticTexts[\"79%\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
        XCTAssertTrue(tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Your Tesla"]/*[[".cells.staticTexts[\"Your Tesla\"]",".staticTexts[\"Your Tesla\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
        XCTAssertTrue(tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["State"]/*[[".cells.staticTexts[\"State\"]",".staticTexts[\"State\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
        XCTAssertTrue(tablesQuery/*@START_MENU_TOKEN@*/.buttons["Unlock"]/*[[".cells.buttons[\"Unlock\"]",".buttons[\"Unlock\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
        XCTAssertTrue(tablesQuery/*@START_MENU_TOKEN@*/.buttons["Open port"]/*[[".cells.buttons[\"Open port\"]",".buttons[\"Open port\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
        XCTAssertTrue(tablesQuery/*@START_MENU_TOKEN@*/.buttons["Turn climate on"]/*[[".cells.buttons[\"Turn climate on\"]",".buttons[\"Turn climate on\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
        XCTAssertTrue(tablesQuery/*@START_MENU_TOKEN@*/.buttons["Open Frunk"]/*[[".cells.buttons[\"Open Frunk\"]",".buttons[\"Open Frunk\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
        XCTAssertTrue(tablesQuery/*@START_MENU_TOKEN@*/.buttons["Open Trunk"]/*[[".cells.buttons[\"Open Trunk\"]",".buttons[\"Open Trunk\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
    }
    
    func logout() {
        if app.buttons["Settings"].exists {
            app.buttons["Settings"].tap()
            app.buttons["Log out"].tap()
            sleep(2)
        }
    }

}
