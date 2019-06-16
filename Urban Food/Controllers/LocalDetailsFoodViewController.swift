//
//  LocalDetailsFoodViewController.swift
//  Urban Food
//
//  Created by Gagansher KHARA on 25/5/19.
//  Copyright © 2019 Gagansher KHARA. All rights reserved.
//

import UIKit

class LocalDetailsFoodViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: LocalRestaurantDetailHeaderView!
    
    var restaurant = RestaurantMO()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
        navigationItem.largeTitleDisplayMode = .never
        
        // Configure the header view
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.tintColor = .white
//        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = restaurant.name
        
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
        
        if let restaurantImage = restaurant.image {
            headerView.headerImageView.image = UIImage(data: restaurantImage as Data)
        }
        
        headerView.nameLabel.text = restaurant.name
        headerView.typeLabel.text = restaurant.type
        headerView.heartImageView.isHidden = restaurant.isVisited ? false : true
        
        if let rating = restaurant.rating {
            headerView.ratingImageView.image = UIImage(named: rating)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailIconTextCell.self), for: indexPath) as! RestaurantDetailIconTextCell
            cell.iconImageView?.image = UIImage(named: "phone")
            cell.shortTextLabel?.text = restaurant.phone
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailIconTextCell.self), for: indexPath) as! RestaurantDetailIconTextCell
            cell.iconImageView?.image = UIImage(named: "map")
            cell.shortTextLabel?.text = restaurant.location
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailTextCell.self), for: indexPath) as! RestaurantDetailTextCell
            cell.descriptionLabel.text = restaurant.restDescription
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailSeparatorCell.self), for: indexPath) as! RestaurantDetailSeparatorCell
            cell.titleLabel.text = "HOW TO GET HERE"
            return cell
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailMapCell.self), for: indexPath) as! RestaurantDetailMapCell
            cell.configure(location: restaurant.location!)
            return cell
            
        default:
            fatalError("Fatal error")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMap" {
            let destinationController = segue.destination as! MapViewController
            destinationController.restaurant1 = restaurant
            
            let backItem = UIBarButtonItem()
            backItem.title = restaurant.name
            navigationItem.backBarButtonItem = backItem
            
        } else if segue.identifier == "showReview" {
            let destinationController = segue.destination as! LocalReviewViewController
            destinationController.restaurant = restaurant
        }
    }
    
    @IBAction func close(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rateRestaurant(segue: UIStoryboardSegue) {
        dismiss(animated: true) {
            if let rating = segue.identifier {
                self.restaurant.rating = rating
                self.headerView.ratingImageView.image = UIImage(named: rating)
                
                if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                    appDelegate.saveContext()
                }
                
                let scaleTransform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                self.headerView.ratingImageView.transform = scaleTransform
                self.headerView.ratingImageView.alpha = 0.0
                
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.7, options: [], animations: {
                    self.headerView.ratingImageView.transform = .identity
                    self.headerView.ratingImageView.alpha = 1.0
                }, completion: nil)
            }
        }
        
    }

}
