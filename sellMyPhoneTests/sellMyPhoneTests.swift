//
//  sellMyPhoneTests.swift
//  sellMyPhoneTests
//
//  Created by Quentin Noblet on 27/02/2018.
//  Copyright © 2018 Quentin Noblet. All rights reserved.
//

// Test to do
// Check device Capacity
// Check device has touch ID
// Test call to API (device list and price for state)

import XCTest
@testable import sellMyPhone

class sellMyPhoneTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

  
  func testAPIDeviceInfoForOneDevice() {
    // 1. given
    let deviceName = "iphone-4s-64go"
    let promise = expectation(description: "Result received")
    // 2. when
    API.shared.fetchDevicesInfo(deviceName: deviceName) { (result) in
      XCTAssertEqual(result[7], "iPhone 4S 64Go", "fetchDeviceInfo for one device doesn't work")
      promise.fulfill()
    }
    // 3. then
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func testAPIDeviceInfoForMultipleDevices() {
    // 1. given
    let deviceName = "iphone-4s"
    let promise = expectation(description: "Result received")
    // 2. when
    API.shared.fetchDevicesInfo(deviceName: deviceName) { (result) in
      XCTAssertEqual(result, [4: "iPhone 4S 8Go", 5: "iPhone 4S 16Go", 6: "iPhone 4S 32Go", 7: "iPhone 4S 64Go"], "fetchDeviceInfo for multiple devices doesn't work")
      promise.fulfill()
    }
    // 3. then
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  
  func testAPIDevicePriceForState() {
    // 1. given
    let deviceId = 269
    let deviceState = DeviceState.shared
    let promise = expectation(description: "Result received")
    // 2. when
    API.shared.priceForState(deviceId: deviceId, deviceState: deviceState) { (result) in
      
      XCTAssertEqual(result > 0.0, true, "fetchPriceForState doesn't work")
      promise.fulfill()
    }
    // 3. then
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  
  
  func testPerformanceExample() {
    self.measure {
      // 1. given
      let deviceId = 269
      let deviceState = DeviceState.shared
      let promise = expectation(description: "Result received")
      // 2. when
      API.shared.priceForState(deviceId: deviceId, deviceState: deviceState) { (result) in
        
        XCTAssertEqual(result > 0.0, true, "fetchPriceForState doesn't work")
        promise.fulfill()
      }
      // 3. then
      waitForExpectations(timeout: 3, handler: nil)
    }
  }
}
