//
//  LocationViewController.swift
//  Urban Food
//
//  Created by Gagansher KHARA on 18/5/19.
//  Copyright © 2019 Gagansher KHARA. All rights reserved.
//

import UIKit

protocol LocationActions: class {
    func didTapAllow()
    
    func didTapDeny()
}

class LocationViewController: UIViewController {
    
    @IBOutlet weak var locationView: LocationView!
    weak var delegate: LocationActions?
    @IBOutlet weak var locationViewImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationView.didTapAllow = {
            self.delegate?.didTapAllow()
        }
        
        locationView.didTapDeny = {
            self.locationViewImage.image = UIImage(named: "401 Unauthorised")
            self.locationViewImage.contentMode = .scaleAspectFit
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
