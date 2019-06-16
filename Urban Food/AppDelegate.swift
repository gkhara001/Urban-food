//
//  AppDelegate.swift
//  Urban Food
//
//  Created by Gagansher KHARA on 18/5/19.
//  Copyright © 2019 Gagansher KHARA. All rights reserved.
//

import UIKit
import Moya
import CoreData
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let window = UIWindow()
    let locationService = LocationService()
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let service = MoyaProvider<YelpService.BusinessesProvider>()
    let jsonDecoder = JSONDecoder()
    var navigationController: UINavigationController?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        locationService.didChangeStatus = { [weak self] success in
            if success {
                self?.locationService.getLocation()
            }
        }
        
        locationService.newLocation = { [weak self] result in
            switch result {
            case .success(let location):
                self?.loadBusinesses(with: location.coordinate)
            case .failure(let error):
                assertionFailure("Error getting the users location \(error)")
            }
        }
        
        switch locationService.status {
        case .notDetermined, .denied, .restricted:
            let locationViewController = storyboard.instantiateViewController(withIdentifier: "LocationViewController") as? LocationViewController
            locationViewController?.delegate = self
            window.rootViewController = locationViewController
        default:
            let nav = storyboard
                .instantiateViewController(withIdentifier: "RestaurantTabBarController") as? UITabBarController
            self.navigationController = nav?.viewControllers?.first as? UINavigationController
            window.rootViewController = nav
            locationService.getLocation()
            ((nav?.viewControllers?.first as! UINavigationController).topViewController as? RestaurantTableViewController)?.delegete = self
        }
        window.makeKeyAndVisible()
        
        return true
    }
    
    private func loadDetails(for viewController: UIViewController, withId id: String) {
        service.request(.details(id: id)) { [weak self] (result) in
            switch result {
            case .success(let response):
                guard let strongSelf = self else { return }
                if let details = try? strongSelf.jsonDecoder.decode(Details.self, from: response.data) {
                    let detailsViewModel = DetailsViewModel(details: details)
                    (viewController as? DetailsFoodViewController)?.viewModel = detailsViewModel
                }
            case .failure(let error):
                print("Failed to get details \(error)")
            }
        }
    }
    
    private func loadBusinesses(with coordinate: CLLocationCoordinate2D) {
        service.request(.search(lat: coordinate.latitude, long: coordinate.longitude)) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                let root = try? strongSelf.jsonDecoder.decode(Root.self, from: response.data)
                let viewModels = root?.businesses
                    .compactMap(RestaurantListViewModel.init)
                    .sorted(by: { $0.distance < $1.distance })
                
                if let nav = strongSelf.window.rootViewController as? UITabBarController,
                    let restaurantListViewController = (nav.viewControllers?.first as! UINavigationController).topViewController as? RestaurantTableViewController {
                    restaurantListViewController.viewModels = viewModels ?? []
                } else if let nav = strongSelf.storyboard
                    .instantiateViewController(withIdentifier: "RestaurantTabBarController") as? UITabBarController {
                    strongSelf.navigationController = nav.viewControllers?.first as? UINavigationController
                    strongSelf.window.rootViewController?.present(nav, animated: true) {
                        ((nav.viewControllers?.first as! UINavigationController).topViewController as? RestaurantTableViewController)?.delegete = self
                        ((nav.viewControllers?.first as! UINavigationController).topViewController as? RestaurantTableViewController)?.viewModels = viewModels ?? []
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
//    func getUserCurrentLocation(with coordinate: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
//        return coordinate
//    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Urban_Food")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()


    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

extension AppDelegate: LocationActions, ListActions {
    func didTapDeny() {
        
    }
    
    func didTapAllow() {
        locationService.requestLocationAuthorization()
    }

    func didTapCell(_ viewController: UIViewController, viewModel: RestaurantListViewModel) {
        loadDetails(for: viewController, withId: viewModel.id)
    }
    
}

