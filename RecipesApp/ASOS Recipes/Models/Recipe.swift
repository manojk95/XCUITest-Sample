//
//  Recipe.swift
//  ASOS Recipes
//

import Foundation

extension CodingUserInfoKey {
    /// Specifies the difficulty classifier to be used to classify the difficulty of this
    /// recipe.
    static let recipeDifficultyClassifier = CodingUserInfoKey (
        rawValue: "recipeDifficultyClassifier")!
}

struct Recipe: Equatable {
    /// A recipe ingredient.
    struct Ingredient: Decodable, Equatable {
        let quantity: String
        let name: String
        let type: String
    }
    
    /// A recipe step.
    struct Step: Equatable {
        let description: String
        let duration: TimeInterval
        
        init (description: String, duration: Int) {
            self.description = description
            self.duration = TimeInterval (duration * 60)
        }
    }
    
    /// Recipe difficulty.
    enum Difficulty: Int, CaseIterable {
        case easy, medium, hard
    }
    
    /// Recipe time range.
    enum TimeRange: Int, CaseIterable {
        case zeroToTen, tenToTwenty, moreThanTwenty
    }
    
    let name: String
    let ingredients: [Ingredient]
    let steps: [Step]
    let imageURL: URL
    let originalURL: URL?
    
    // Non-JSON properties.
    fileprivate(set) var difficulty: Difficulty!
    
    /// The total duration, in seconds, of this recipe.
    var duration: TimeInterval {
        return self.steps.map { $0.duration }.reduce (0, +)
    }
    
    /// The time range of this recipe.
    var timeRange: TimeRange {
        switch self.duration / 60 { // minutes
        case 0..<10:
            return .zeroToTen
        case 10...20:
            return .tenToTwenty
        default:
            return .moreThanTwenty
        }
    }
    
    /// Normal keys used to map the external object to this.
    enum CodingKeys: String, CodingKey {
        case name, ingredients, imageURL, originalURL
    }
    
    /// Keys used to decode `Step`s in a better format.
    enum StepKeys: String, CodingKey {
        case steps, timers
    }
}

extension Recipe: Decodable {
    init (from decoder: Decoder) throws {
        // Decode basic keys as usual.
        let values = try decoder.container (keyedBy: CodingKeys.self)
        self.name = try values.decode (String.self, forKey: .name)
        self.ingredients = try values.decode ([Ingredient].self, forKey: .ingredients)
        self.imageURL = try values.decode (URL.self, forKey: .imageURL)
        self.originalURL = try? values.decode (URL.self, forKey: .originalURL)
        // Steps and timers are stored in two differents arrays -- map them to our `Step`
        // object.
        let stepData = try decoder.container (keyedBy: StepKeys.self)
        let stepDescriptions = try stepData.decode ([String].self, forKey: .steps)
        let stepTimers = try stepData.decode ([Int].self, forKey: .timers)
        // One line away from everything being mapped to `Recipe.Step` thanks to the magic of
        // Swift.
        self.steps = zip (stepDescriptions, stepTimers).map (Recipe.Step.init)
        // If a difficulty classifier was provided in user info
        if let difficultyClassifier = decoder.userInfo[.recipeDifficultyClassifier]
            as? RecipeDifficultyClassifier {
            self.difficulty = difficultyClassifier.difficulty (for: self)
        } else {
            debugPrint ("WARNING: Recipe \(self.name) instantiated without difficulty classifier")
        }
    }
}
