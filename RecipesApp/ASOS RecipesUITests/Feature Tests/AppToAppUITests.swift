//
//  AppToAppUITests.swift
//  ASOS RecipesUITests
//
//  Created by Manoj Kumar Barik on 20/05/2022.
//  Copyright © 2022 Roberto Frenna. All rights reserved.
//

import Foundation
import XCTest

class AppToAppUITests: MainTest {

    func testVerifyAppToAppNavigation() {
        givenIAmOnHomePage()
        andIShouldSeeRecipesLoaded()
        whenISelectTheRecipe()
        andISelectRecipeLinkImage()
//        thenIVerifyWebPage()
//        whenISelectReturnToASOSButton()
//        thenIVerifyRecipeHeader()

    }
}
