//
//  sellMyPhoneUITests.swift
//  sellMyPhoneUITests
//
//  Created by Quentin Noblet on 27/02/2018.
//  Copyright © 2018 Quentin Noblet. All rights reserved.
//

import XCTest
@testable import sellMyPhone


class sellMyPhoneUITests: XCTestCase {
        var app: XCUIApplication!
    override func setUp() {
        super.setUp()
      
        continueAfterFailure = false
      app = XCUIApplication()
      app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testRequestTouchId() {
      let app = XCUIApplication()
      let dMarrerLeTestButton = app.buttons["Démarrer le TEST"]
      dMarrerLeTestButton.tap()
      app.alerts.buttons["Annuler"].tap()
    }
    
}
