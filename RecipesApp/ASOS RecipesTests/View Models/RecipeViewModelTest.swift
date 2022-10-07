//
//  RecipeViewModelTest.swift
//  ASOS RecipesTests
//

import XCTest
@testable import ASOS_Recipes

class RecipeViewModelTest: XCTestCase {
    var recipe: Recipe!
    var apiService: APIServiceMock!
    var sut: RecipeViewModel!
    
    func initViewModel() -> RecipeViewModel {
        return RecipeViewModel (
            recipe: recipe,
            dependencies: AppDependencies (
                apiService: apiService,
                recipeDifficultyClassifier: RecipeDifficultyClassifierMock ()
            )
        )
    }
    
    override func setUp() {
        super.setUp()
        apiService = APIServiceMock()
        recipe = StaticResponse.oneRecipe.recipes![0]
        sut = initViewModel()
    }
    
    override func tearDown() {
        sut = nil
        recipe = nil
        apiService = nil
        super.tearDown()
    }
    
    func testMakesRequestOnInit() {
        let exp = expectation (description: "RecipeViewModel requests image on init")
        apiService.onRequest = { url in
            XCTAssertEqual (url, self.recipe.imageURL)
            exp.fulfill()
        }
        _ = initViewModel()
        wait (for: [exp], timeout: 1)
    }
    
    func testAccessors() {
        XCTAssertEqual (sut.name, recipe.name)
        XCTAssertEqual (sut.numberOfIngredients, recipe.ingredients.count)
        XCTAssertEqual (sut.numberOfSteps, recipe.steps.count)
        let firstStep = sut.step (for: IndexPath(row: 0, section: 0))
        let firstIngredient = sut.ingredient (for: IndexPath(row: 0, section: 0))
        XCTAssertEqual (firstIngredient, recipe.ingredients[0])
        XCTAssertEqual (firstStep, recipe.steps[0])
    }
}
