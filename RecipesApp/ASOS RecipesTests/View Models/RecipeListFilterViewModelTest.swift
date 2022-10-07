//
//  RecipeListFilterViewModelTest.swift
//  ASOS RecipesTests
//

import XCTest
@testable import ASOS_Recipes

class RecipeListFilterViewModelTest: XCTestCase, RecipeListFilterViewModelDelegate {
    var sut: RecipeListFilterViewModel!
    
    enum FilterType: Int {
        case difficulty = 100, timeRange = 200
    }
    override func setUp() {
        super.setUp()
        sut = RecipeListFilterViewModel (currentFilter: nil)
        sut.delegate = self
    }
    
    override func tearDown() {
        sut.delegate = nil
        sut = nil
        super.tearDown()
    }
    
    func testEveryFilterByDefault() {
        // test difficulties
        for difficulty in Recipe.Difficulty.allCases {
            XCTAssert (sut.hasFilter (at: makeIndexPath (for: .difficulty, value: difficulty)))
        }
        // test time ranges
        for timeRange in Recipe.TimeRange.allCases {
            XCTAssert (sut.hasFilter (at: makeIndexPath (for: .timeRange, value: timeRange)))
        }
    }
    
    func testDifficultyFilter() {
        // test difficulty: medium
        let indexPath = makeIndexPath (for: .difficulty, value: Recipe.Difficulty.medium)
        XCTAssert (!sut.toggleFilter (at: indexPath))
        XCTAssert (!sut.hasFilter (at: indexPath))
        // toggle again
        XCTAssert (sut.toggleFilter (at: indexPath))
        XCTAssert (sut.hasFilter(at: indexPath))
        // ensure everything else is back as before
        testEveryFilterByDefault()
    }
    
    func testTimeRangeFilter() {
        // test time range: zero to ten
        let indexPath = makeIndexPath (for: .timeRange, value: Recipe.TimeRange.zeroToTen)
        XCTAssert (!sut.toggleFilter (at: indexPath))
        XCTAssert (!sut.hasFilter (at: indexPath))
        // toggle again
        XCTAssert (sut.toggleFilter (at: indexPath))
        XCTAssert (sut.hasFilter (at: indexPath))
        // ensure everything else is back as before
        testEveryFilterByDefault()
    }
    
    func testPropagatesCancellation() {
        let fakeDelegate = CoordinatorDelegateTester()
        fakeDelegate.expectedResult = nil
        fakeDelegate.expectation = expectation (description: "filter VM cancels properly")
        sut.coordinatorDelegate = fakeDelegate
        sut.onCancel()
        wait (for: [fakeDelegate.expectation], timeout: 1)
    }
    
    func testResult() {
        // toggle hard difficulty and 10-20 time range
        _ = sut.toggleFilter (at: makeIndexPath (for: .difficulty,
                                                 value: Recipe.Difficulty.hard))
        _ = sut.toggleFilter (at: makeIndexPath (for: .timeRange,
                                                 value: Recipe.TimeRange.tenToTwenty))
        // generate the expected result
        var expectedResult = RecipeListFilter()
        expectedResult.allowedTimeRanges.remove (.tenToTwenty)
        expectedResult.allowedDifficulties.remove (.hard)
        // use the fake delegate to check if everything is alright
        let fakeDelegate = CoordinatorDelegateTester()
        fakeDelegate.expectedResult = expectedResult
        fakeDelegate.expectation = expectation (description: "RecipeListFilter is sane")
        sut.coordinatorDelegate = fakeDelegate
        sut.onFinish()
        wait (for: [fakeDelegate.expectation], timeout: 1)
    }
    
    func makeIndexPath<T: RawRepresentable>(for filterType: FilterType,
                                            value: T) -> IndexPath where T.RawValue == Int {
        return IndexPath (
            row: value.rawValue,
            section: filterType.rawValue
        )
    }
    
    // MARK: RecipeListFilterViewModelDelegate
    func resolveFilterType (with indexPath: IndexPath) -> RecipeListFilterViewModelFilterType {
        switch indexPath.section {
        case FilterType.difficulty.rawValue:
            return .difficulty
        case FilterType.timeRange.rawValue:
            return .timeRange
        default:
            XCTFail ("Received unknown index path")
            preconditionFailure ("Test failed")
        }
    }
    
    class CoordinatorDelegateTester: RecipeListFilterViewModelCoordinatorDelegate {
        var expectation: XCTestExpectation!
        var expectedResult: RecipeListFilter?
        
        func filterViewFinished (result: RecipeListFilter?) {
            XCTAssertEqual (expectedResult, result)
            expectation.fulfill()
        }
    }
}
