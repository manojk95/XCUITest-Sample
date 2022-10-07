//
//  WebPageScreens.swift
//  ASOS RecipesUITests
//
//  Created by Manoj Kumar Barik on 20/05/2022.
//  Copyright © 2022 Roberto Frenna. All rights reserved.
//

import Foundation
import XCTest

let safari = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
let returnToASOSButton = safari.navigationBars.otherElements.element(matching: .button, identifier: "breadcrumb").firstMatch
let recipeWebPageTitle = safari.webViews.staticTexts.element(boundBy: 0)

    
