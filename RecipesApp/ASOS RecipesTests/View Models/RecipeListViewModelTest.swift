//
//  RecipeListViewModelTest.swift
//  ASOS RecipesTests
//

import XCTest
@testable import ASOS_Recipes

class RecipeListViewModelTest: XCTestCase {
    var apiService: APIServiceMock!
    var sut: RecipeListViewModel!
    
    override func setUp() {
        super.setUp()
        apiService = APIServiceMock (staticData: [
            .getRecipes: StaticResponse.oneRecipe.value
        ])
        sut = RecipeListViewModel (dependencies: AppDependencies (
            apiService: apiService,
            recipeDifficultyClassifier: RecipeDifficultyClassifierMock (
                classifyAllTo: .hard
            )
        ))
    }
    
    override func tearDown() {
        sut = nil
        apiService = nil
        super.tearDown()
    }
    
    func testDataRetrieval() {
        let exp = expectation (
            description: "delegate screen updater method is called from RecipeListViewModel"
        )
        let fakeDelegate = ViewModelDelegateTester()
        fakeDelegate.expectation = exp
        sut.delegate = fakeDelegate
        sut.refreshData()
        XCTAssert (sut.numberOfItems == 1)
        wait (for: [exp], timeout: 1)
    }
    
    func testDataFiltering() {
        sut.refreshData()
        var filter = RecipeListFilter()
        filter.allowedDifficulties = [.easy]
        sut.changeFilter (to: filter)
        XCTAssert (sut.numberOfItems == 0)
    }
    
    func testDataSearching() {
        sut.refreshData()
        sut.search (for: "something that doesn't exist")
        XCTAssert (sut.numberOfItems == 0)
    }
    
    func testNavigation() {
        let showRecipeExpectation = expectation (
            description: "tap on recipe goes to recipe detail")
        let openFilterExpectation = expectation (
            description: "tap on filter goes to filter screen")
        let fakeDelegate = CoordinatorDelegateTester()
        fakeDelegate.openFilterExpectation = openFilterExpectation
        fakeDelegate.showRecipeExpectation = showRecipeExpectation
        sut.coordinatorDelegate = fakeDelegate
        sut.refreshData()
        sut.didTapRecipe (at: IndexPath(row: 0, section: 0))
        wait (for: [showRecipeExpectation], timeout: 1)
        sut.didTapFilterButton()
        wait (for: [openFilterExpectation], timeout: 1)
    }
    
    class ViewModelDelegateTester: RecipeListViewModelDelegate {
        var expectation: XCTestExpectation!
        
        func showNetworkError (withMessage message: String) {}
        
        func updateScreen() {
            expectation.fulfill()
        }
    }
    
    class CoordinatorDelegateTester: RecipeListViewModelCoordinatorDelegate {
        var showRecipeExpectation: XCTestExpectation!
        var openFilterExpectation: XCTestExpectation!
        
        func showRecipe (_ recipe: Recipe) {
            showRecipeExpectation.fulfill()
        }
        
        func openFilterSelectionScreen(withCurrentFilter currentFilter: RecipeListFilter?) {
            openFilterExpectation.fulfill()
        }
    }
}
