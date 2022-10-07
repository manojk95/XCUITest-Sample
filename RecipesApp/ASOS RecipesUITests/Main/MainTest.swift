//
//  MainTest.swift
//  ASOS RecipesUITests
//
//  Created by Manoj Kumar Barik on 20/05/2022.
//  Copyright © 2022 Roberto Frenna. All rights reserved.
//

import Foundation
import XCTest

class MainTest: XCTestCase {
    
    let app = XCUIApplication()
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDown() {
        XCUIApplication().terminate()
        super.tearDown()
    }
    
    func takeScreenShot(_ element:XCUIElement) {
        element.screenshot()
    }
    
    func XCTAsyncAssert(_ element:XCUIElement, errorMessage:String) {
        let isElementExists = element.waitForExistence(timeout: 1)
        if isElementExists {
            XCTAssertTrue(element.exists,errorMessage)
        }
    }
    
    func click(_ element:XCUIElement) {
        let isElementExists = element.waitForExistence(timeout: 1)
        if isElementExists {
            element.tap()
        }
    }
    
    func doubleClick(_ element:XCUIElement) {
        let isElementExists = element.waitForExistence(timeout: 1)
        if isElementExists {
            element.doubleTap()
        }
    }
    
    func swipeUntilFound(_ element:XCUIElement,_ swipeInToElement:XCUIElement) {
        while !swipeInToElement.exists {
            element.swipeUp()
        }
    }
    
    func enterText(_ element:XCUIElement, value:String) {
        let isElementExists = element.waitForExistence(timeout: 1)
        if isElementExists{
            element.tap()
            element.typeText(value)
        }
    }
}
