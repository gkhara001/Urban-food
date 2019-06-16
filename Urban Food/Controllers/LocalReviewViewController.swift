//
//  LocalReviewViewController.swift
//  Urban Food
//
//  Created by Gagansher KHARA on 25/5/19.
//  Copyright © 2019 Gagansher KHARA. All rights reserved.
//

import UIKit

class LocalReviewViewController: UIViewController {

    @IBOutlet var ratings: [UIButton]!
    
    @IBOutlet var backgroundImageView: UIImageView!
    
    var restaurant: RestaurantMO!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let restaurantimage = restaurant.image {
            backgroundImageView.image = UIImage(data: restaurantimage as Data)
        }
        
        // Applying the blur effect
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        let moveRightTransform = CGAffineTransform.init(translationX: 600, y: 0)
        let scaleUpTransform = CGAffineTransform.init(scaleX: 5.0, y: 5.0)
        let moveScaleTransform = scaleUpTransform.concatenating(moveRightTransform)
        
        // Make the buttons invisible
        for rateButton in ratings {
            rateButton.transform = moveScaleTransform
            rateButton.alpha = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 0.8, delay: 0.1, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.3, options: [], animations: {
            self.ratings[0].alpha = 1.0
            self.ratings[0].transform = .identity
        }, completion: nil)
        
        UIView.animate(withDuration: 0.8, delay: 0.15, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.3, options: [], animations: {
            self.ratings[1].alpha = 1.0
            self.ratings[1].transform = .identity
        }, completion: nil)
        
        UIView.animate(withDuration: 0.8, delay: 0.20, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.3, options: [], animations: {
            self.ratings[2].alpha = 1.0
            self.ratings[2].transform = .identity
        }, completion: nil)
        
        UIView.animate(withDuration: 0.8, delay: 0.25, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.3, options: [], animations: {
            self.ratings[3].alpha = 1.0
            self.ratings[3].transform = .identity
        }, completion: nil)
        
        UIView.animate(withDuration: 0.8, delay: 0.30, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.3, options: [], animations: {
            self.ratings[4].alpha = 1.0
            self.ratings[4].transform = .identity
        }, completion: nil)
        
        UIView.animate(withDuration: 0.8, delay: 0.35, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.3, options: [], animations: {
            self.ratings[5].alpha = 1.0
            self.ratings[5].transform = .identity
        }, completion: nil)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

