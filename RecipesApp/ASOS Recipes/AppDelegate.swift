//
//  AppDelegate.swift
//  ASOS Recipes
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appCoordinator: Coordinator!
    
    func application (_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Create a new window and a root navigation controller.
        let rootController = UINavigationController()
        self.window = UIWindow (frame: UIScreen.main.bounds)
        // Create the NetworkFetcher.
        let urlSession = URLSession (configuration: .default)
        // Disable caching as that is taken care of by our caching layer.
        urlSession.configuration.urlCache = nil
        // Instantiate the cache.
        let cache = try! MemoryAndDiskCache (
            policy: .expires (after: 60 * 60),
            namespace: "asos-recipes"
        )
        // Create the dependencies bundle.
        let dependencies = AppDependencies (
            apiService: CachedAPIService (cache: cache, networkFetcher: urlSession),
            recipeDifficultyClassifier: StepAndIngredientCountRecipeDifficultyClassifier()
        )
        // Instantiate the main coordinator.
        self.appCoordinator = AppCoordinator (
            router: rootController,
            dependencies: dependencies
        )
        // Start and display everything.
        self.window?.rootViewController = rootController
        self.window?.makeKeyAndVisible()
        self.appCoordinator.start()
        return true
    }
}

