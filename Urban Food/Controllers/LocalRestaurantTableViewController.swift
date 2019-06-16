//
//  LocalRestaurantTableViewController.swift
//  Urban Food
//
//  Created by Gagansher KHARA on 24/5/19.
//  Copyright © 2019 Gagansher KHARA. All rights reserved.
//

import UIKit
import CoreData

class LocalRestaurantTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating{
    
    
    @IBOutlet var emptyRestaurantView: UIView!
    
    
    var restaurants: [RestaurantMO] = []
    var fetchResultController: NSFetchedResultsController<RestaurantMO>!
    var searchController: UISearchController?
    var searchResults: [RestaurantMO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = emptyRestaurantView
        tableView.backgroundView?.isHidden = true
        
        // Search controller
        searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        
        // Search bar in tableview header
        //        tableView.tableHeaderView = searchController?.searchBar
        searchController?.searchResultsUpdater = self
        searchController?.dimsBackgroundDuringPresentation = false
        searchController?.searchBar.placeholder = "Search restaurants..."
        searchController?.searchBar.barTintColor = .white
        searchController?.searchBar.backgroundImage = UIImage()
//        searchController?.searchBar.tintColor = UIColor(red: 231, green: 76, blue: 60)
        
        // Fetch data from data store
        let fetchRequest: NSFetchRequest<RestaurantMO> = RestaurantMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    restaurants = fetchedObjects
                }
            } catch {
                print(error)
            }
        }

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if restaurants.count > 0 {
            tableView.backgroundView?.isHidden = true
        } else {
            tableView.backgroundView?.isHidden = false
        }
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (searchController?.isActive)! {
            return searchResults.count
        } else {
            return restaurants.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocalRestaurantCell", for: indexPath) as! RestaurantTableViewCell

        // Determine if we get the restaurant from search result or the original array
        let restaurant = (searchController?.isActive)! ? searchResults[indexPath.row] : restaurants[indexPath.row]
        
        // Configure the cell...
        cell.makerImageView.isHidden = restaurant.isVisited ? false : true
        cell.restaurantNameLabel.text = restaurant.name
        
        if let restaurantImage = restaurant.image {
            cell.restaurantImageView.image = UIImage(data: restaurantImage)
        }
        
        return cell
    }
 
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                
                let restaurantToDelete = self.fetchResultController.object(at: indexPath)
                
                context.delete(restaurantToDelete)
                
                appDelegate.saveContext()
                
            }
            
            // Call completion handler to dismiss the action button
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = UIColor.red
        deleteAction.image = UIImage(named: "delete")
        
        let shareAction = UIContextualAction(style: .normal, title: "Share") { (action, sourceView, completionHandler) in
            let defaultText = "Just checking in at \(self.restaurants[indexPath.row].name!)"
            let activityController: UIActivityViewController
            
            if let restaurantImage = self.restaurants[indexPath.row].image,
                let imageToShare = UIImage(data: restaurantImage as Data) {
                activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
            } else {
                activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
            }
            
            if let popoverController = activityController.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }
            
            self.present(activityController, animated: true, completion: nil)
            completionHandler(true)
        }
        
        shareAction.backgroundColor = UIColor.orange
        shareAction.image = UIImage(named: "share")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        return swipeConfiguration
    }
    
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let checkInAction = UIContextualAction(style: .normal, title: "Favourite") { (action, sourceView, completionHandler) in
            let cell = tableView.cellForRow(at: indexPath) as! RestaurantTableViewCell
            self.restaurants[indexPath.row].isVisited = (self.restaurants[indexPath.row].isVisited) ? false : true
            cell.makerImageView.isHidden = (self.restaurants[indexPath.row].isVisited) ? false : true
            
            completionHandler(true)
        }
        
        // Customize the action button
        checkInAction.backgroundColor = UIColor.purple
        
        checkInAction.image = self.restaurants[indexPath.row].isVisited ? UIImage(named: "undo") : UIImage(named: "tick")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [checkInAction])
        
        return swipeConfiguration
    }
    
    // Disable share and delete buttons when in search mode
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (searchController?.isActive)! {
            return false
        } else {
            return true
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRestaurantDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destination = segue.destination as! LocalDetailsFoodViewController
                destination.restaurant = (searchController?.isActive)! ? searchResults[indexPath.row] : restaurants[indexPath.row]
                
                let backItem = UIBarButtonItem()
                backItem.title = "Urban Food"
                navigationItem.backBarButtonItem = backItem
            }
            
        }
    }


    
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        
        if let fetchedObjects = controller.fetchedObjects {
            restaurants = fetchedObjects as! [RestaurantMO]
        }
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
        tableView.endUpdates()
    }
    
    private func filterContent(for searchText: String) {
        searchResults = restaurants.filter({ (restaurant) -> Bool in
            
            if let name = restaurant.name, let location = restaurant.location {
                let isMatch = name.localizedCaseInsensitiveContains(searchText) || location.localizedStandardContains(searchText)
                return isMatch
            }
            
            return false
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }
}

extension LocalRestaurantTableViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location) else {
            return nil
        }
        
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return nil
        }
        
        guard let restaurantDetailViewController = storyboard?.instantiateViewController(withIdentifier: "LocalDetailsFoodViewController") as? LocalDetailsFoodViewController else {
            return nil
        }
        
        let selectedRestaurant = restaurants[indexPath.row]
        restaurantDetailViewController.restaurant = selectedRestaurant
        restaurantDetailViewController.preferredContentSize = CGSize(width: 0.0, height: 460.0)
        previewingContext.sourceRect = cell.frame
        return restaurantDetailViewController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
}


