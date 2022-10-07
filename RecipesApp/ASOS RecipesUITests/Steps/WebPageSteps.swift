//
//  WebPageSteps.swift
//  ASOS RecipesUITests
//
//  Created by Manoj Kumar Barik on 20/05/2022.
//  Copyright © 2022 Roberto Frenna. All rights reserved.
//

import Foundation
import XCTest

extension MainTest{
    
    func thenIVerifyWebPage() {
        XCTContext.runActivity(named: "Then I verify web page") { _ in
            let title = recipeWebPageTitle.title
            print(title)
            XCTAsyncAssert(recipeWebPageTitle, errorMessage: "Web Page did not load")
        }
    }
    func whenISelectReturnToASOSButton(){
        XCTContext.runActivity(named: "When I select return to ASOS button") { _ in
            XCTAsyncAssert(returnToASOSButton, errorMessage: "Web Page did not load")
        }
    }
}
