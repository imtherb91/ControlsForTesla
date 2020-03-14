//
//  NetworkTests.swift
//  Controls for Tesla PurchasesTests
//
//  Created by Luke Allen on 3/8/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import XCTest
@testable import Controls_for_Tesla

class NetworkTests: XCTestCase {
    
    var tokenIsGood: Bool {
        SecureData.hasValidToken && !SecureData.shouldRefresh
    }
    
    var authState = AuthState()
    var vehicle: Vehicle?

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testLogin() {
        var resp: OAuthResponse?
        var err: Error?
        let login = expectation(description: "login")
        let cancellable = OAuth.login(email: "luketimallen@gmail.com", password: "testaccount") { (response, error) in
            resp = response
            err = error
            login.fulfill()
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
        
        XCTAssertNotNil(resp)
        XCTAssertTrue(resp?.access_token.isEmpty == false)
        XCTAssertTrue(resp?.refresh_token.isEmpty == false)
        XCTAssertTrue(resp?.created_at ?? 0 > 0)
        XCTAssertTrue(resp?.expires_in ?? 0 > 0)
        XCTAssertNil(err)
    }
    
    func testVehicleList() {
        if !authState.isLoggedIn && !tokenIsGood {
            testLogin()
        }
        let model = VehiclesViewModel(vehicles: [])
        let list = expectation(description: "list")
        model.getList {
            list.fulfill()
        }
        
        waitForExpectations(timeout: 10.0, handler: nil)
        XCTAssertTrue(model.vehicles.count == 1)
        let vehicle = model.vehicles[0]
        XCTAssertNotNil(vehicle.vin)
        XCTAssertNotNil(vehicle.display_name)
        XCTAssertTrue(vehicle.id > 0)
        XCTAssertTrue(vehicle.vehicle_id > 0)
        self.vehicle = vehicle
    }
    
    func testVehicleData() {
        testVehicleList()
        guard let vehicle = self.vehicle else { return }
        let model = VehicleViewModel(vehicle: vehicle)
        let vehicleData = expectation(description: "vehicleData")
        model.getVehicleData {
            vehicleData.fulfill()
        }
        waitForExpectations(timeout: 10.0, handler: nil)
        XCTAssertTrue(model.vehicle.battery_level > 0)
        XCTAssertTrue(model.vehicle.inside_temp > 0.0)
        XCTAssertTrue(model.vehicle.outside_temp > 0.0)
        XCTAssertTrue(model.vehicle.driver_temp_setting > 0.0)
        XCTAssertTrue(model.vehicle.battery_range > 0.0)
    }
    
    func testLock() {
        testVehicleList()
        guard let vehicle = self.vehicle else { return }
        var status = false
        let model = VehicleViewModel(vehicle: vehicle)
        let lock = expectation(description: "lock")
        model.lock { success in
            status = success
            lock.fulfill()
        }
        waitForExpectations(timeout: 10.0, handler: nil)
        XCTAssertTrue(status)
    }
    
    func testLogout() {
        testLogin()
        let logout = expectation(description: "logout")
        var success = false
        let cancellable = Logout.send { status in
            success = status
            logout.fulfill()
        }
        waitForExpectations(timeout: 10.0, handler: nil)
        XCTAssertTrue(success)
    }

}
