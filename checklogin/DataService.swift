//
//  DataService.swift
//  checklogin
//
//  Created by kavita patel on 3/9/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import Foundation
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

let URL_BASE = "https://checklogin.firebaseio.com"
class DataService
{
    static var ds = DataService()
    
    private var _REF_BASE = Firebase(url: "\(URL_BASE)" )
    private var _REF_POSTS = Firebase(url: "\(URL_BASE)/posts")
    private var _REF_USERS = Firebase(url: "\(URL_BASE)/users")
    
    var REF_BASE: Firebase
        {
        return _REF_BASE
    }
    var REF_POST: Firebase
        {
        return _REF_POSTS
    }
    var REF_USER: Firebase
        {
        return _REF_USERS
    }
    var REF_CURRENT_USER: Firebase
        {
        let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
        let user = Firebase(url: "\(URL_BASE)").childByAppendingPath("users").childByAppendingPath(uid)
        return user!
    }
    func createFirebaseUser(uid: String, users: Dictionary<String, String>)
    {
        REF_USER.childByAppendingPath(uid).setValue(users)
    }
}
