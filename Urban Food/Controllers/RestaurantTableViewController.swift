//
//  RestaurantTableTableViewController.swift
//  Urban Food
//
//  Created by Gagansher KHARA on 18/5/19.
//  Copyright © 2019 Gagansher KHARA. All rights reserved.
//

import UIKit

protocol ListActions: class {
    func didTapCell(_ viewController: UIViewController, viewModel: RestaurantListViewModel)
}

class RestaurantTableViewController: UITableViewController, UISearchResultsUpdating {

    private var searchController: UISearchController?
    private var searchResults = [RestaurantListViewModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var viewModels = [RestaurantListViewModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    weak var delegete: ListActions?
    var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var noInternetConnectionGiF: UIImageView!
    @IBOutlet var noInternetbackground: UIView!
    var reachability: Reachability?
    
    override func loadView() {
        super.loadView()
        
        
        activityIndicatorView = UIActivityIndicatorView(style: .gray)
        activityIndicatorView.scale(factor: 3.0)
        activityIndicatorView.color = UIColor.red
        
        
        tableView.backgroundView = activityIndicatorView
        activityIndicatorView.startAnimating()
        
        self.reachability = Reachability.init()
        noInternetConnectionGiF.loadGif(name: "no-internet-digging-v1")

        if ((self.reachability!.connection) != .none) {
            tableView.backgroundView?.isHidden = true
        } else {
            tableView.backgroundView = noInternetbackground
            tableView.backgroundView?.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Search controller
        searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        
        // Search bar in tableview header
        //        tableView.tableHeaderView = searchController?.searchBar
        searchController?.searchResultsUpdater = self
        searchController?.dimsBackgroundDuringPresentation = false
        searchController?.searchBar.placeholder = "Search restaurants in the list..."
        searchController?.searchBar.barTintColor = .white
        searchController?.searchBar.backgroundImage = UIImage()
        searchController?.searchBar.tintColor = UIColor.lightGray
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

       if (viewModels.count > 0) {
            activityIndicatorView.stopAnimating()
            activityIndicatorView.isHidden = true
       }

    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        return viewModels.count
        if (searchController?.isActive)! {
            return searchResults.count
        } else {
            return viewModels.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        activityIndicatorView.stopAnimating()
        activityIndicatorView.isHidden = true
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantTableViewCell
        
        let vm = (searchController?.isActive)! ? searchResults[indexPath.row] : viewModels[indexPath.row]
        cell.configure(with: vm)
        
        return cell
    }
    
    // MARK: - Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailsViewController = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") else { return }
        navigationController?.pushViewController(detailsViewController, animated: true)
        let vm = viewModels[indexPath.row]
        delegete?.didTapCell(detailsViewController, viewModel: vm)
    }
    
    private func filterContent(for searchText: String) {
        searchResults = viewModels.filter({ (restaurant) -> Bool in
            return (restaurant.name.lowercased().contains(searchText.lowercased()))
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }

}

extension UIActivityIndicatorView {
    func scale(factor: CGFloat) {
        guard factor > 0.0 else { return }
        
        transform = CGAffineTransform(scaleX: factor, y: factor)
    }
}
