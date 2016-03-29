//
//  loginView.swift
//  checklogin
//
//  Created by kavita patel on 3/8/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import UIKit

class loginView: UIView {

    // used for view
   override func awakeFromNib() {
        
        layer.cornerRadius = 2.0
layer.shadowColor = UIColor(red: shadowcolor, green: shadowcolor, blue: shadowcolor, alpha: 1.0).CGColor
    layer.shadowRadius = 8.0
    layer.shadowOpacity = 0.8
    layer.shadowOffset = CGSizeMake(0.0, 2.0)
    }

}
