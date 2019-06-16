//
//  LocalRestaurantDetailHeaderView.swift
//  Urban Food
//
//  Created by Gagansher KHARA on 25/5/19.
//  Copyright © 2019 Gagansher KHARA. All rights reserved.
//

import UIKit

class LocalRestaurantDetailHeaderView: UIView {

    
    @IBOutlet weak var headerImageView: UIImageView!

    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.numberOfLines = 0
        }
    }
    @IBOutlet weak var ratingImageView: UIImageView!
    
    @IBOutlet weak var typeLabel: UILabel! {
        didSet {
            typeLabel.layer.cornerRadius = 5.0
            typeLabel.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var heartImageView: UIImageView! {
        didSet {
            heartImageView.image = UIImage(named: "love") //?.withRenderingMode(.alwaysTemplate)
          //  heartImageView.tintColor = .white
        }
    }
    

}
