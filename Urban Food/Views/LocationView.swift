//
//  LocationView.swift
//  Urban Food
//
//  Created by Gagansher KHARA on 18/5/19.
//  Copyright © 2019 Gagansher KHARA. All rights reserved.
//

import UIKit

@IBDesignable class LocationView: BaseView {
    
    @IBOutlet weak var allowButton: UIButton!
    @IBOutlet weak var denyButton: UIButton!
    
    var didTapAllow: (() -> Void)?
    
    var didTapDeny: (() -> Void)?
    
    @IBAction func allowAction(_ sender: UIButton) {
        didTapAllow?()
    }
    
    @IBAction func denyAction(_ sender: UIButton) {
        didTapDeny?()
    }
}
