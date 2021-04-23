//
//  GlobalTestUITests.swift
//  GlobalTestUITests
//
//  Created by Shayan Mehranpoor on 4/21/21.
//

import XCTest

class GlobalTestUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testFetchContentButton() throws {
                
        let responseCodeLbl = app.staticTexts["Response Code: 32e02946-a160-4175-8280-c6561ffa6445"]
        let counterLbl = app.staticTexts["Times Fetched: 15"]
        let fetchContentBtn = app.buttons["Fetch Content"]
        
        XCTAssertTrue(responseCodeLbl.exists)
        XCTAssertTrue(counterLbl.exists)
        fetchContentBtn.tap()
        XCTAssertTrue(responseCodeLbl.exists)
        XCTAssertTrue(counterLbl.exists)

    }
}
