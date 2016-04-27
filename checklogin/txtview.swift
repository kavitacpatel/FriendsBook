//
//  txtview.swift
//  checklogin
//
//  Created by kavita patel on 3/8/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import UIKit

class txtview: UITextField {

    // used for text fields
    override func awakeFromNib() {
        
        layer.cornerRadius = 2.0
        layer.borderColor = UIColor(red: shadowcolor, green: shadowcolor, blue: shadowcolor, alpha: 0.8).CGColor
        layer.borderWidth = 1.0
        
    }
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }
}
