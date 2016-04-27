//
//  ViewController.swift
//  checklogin
//
//  Created by kavita patel on 3/8/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit


class ViewController: UIViewController {

    @IBOutlet weak var txtemail: UITextField!
    @IBOutlet weak var txtpassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

   
    
    @IBAction func btnattemplogin(sender: AnyObject) {
        if let email = txtemail.text where email != "", let pw = txtpassword.text where pw != ""
        {
            DataService.ds.REF_BASE.authUser(email, password: pw, withCompletionBlock: { error, authdata in
                if error != nil
                {
                    if error.code == USER_NO_EXISTS
                    {
                        DataService.ds.REF_BASE.createUser(email, password: pw, withValueCompletionBlock: { error, result -> Void in
                            if error != nil
                            {
                                self.showalert("Error Creating Account", msg: "Try something else..!!!")
                            }
                             else
                            {
                            NSUserDefaults.standardUserDefaults().setValue(result[KEY_UID], forKey: KEY_UID)
                            DataService.ds.REF_BASE.authUser(email, password: pw, withCompletionBlock: { (ErrorType, authdata) -> Void in
                                if error != nil
                                {
                                    self.showalert("Account failed", msg: "Login failed.!!!")
                                }
                                else
                                {
                                    print("Logged in")
                                    let user = ["provider": authdata.provider!]  //facebook provider
                                    DataService.ds.createFirebaseUser(authdata.uid, users: user)
                                }
                            })
                            self.performSegueWithIdentifier(Seque_loggedin, sender: nil)
                            }
                        })
                    }
                    else
                    {
                        self.showalert("Email / Password ", msg: "Please check your email id or password..!!")
                    }
                    
                }
                else
                {
                    self.performSegueWithIdentifier(Seque_loggedin, sender: nil)

                }
            
                })
        }
        else
        {
            showalert("Email / Password ", msg: "You must enter Email and Password.!!")
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil
        {
          self.performSegueWithIdentifier(Seque_loggedin, sender: nil)
        }
    }

    func showalert(title: String, msg:String)
    {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let alertaction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(alertaction)
        presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func fbloginbtn(sender: UIButton) {
       let facebooklogin = FBSDKLoginManager()
               facebooklogin.logInWithReadPermissions(["email"]) { (facebookresult: FBSDKLoginManagerLoginResult!,fberror: NSError!) -> Void in
            if fberror != nil
            {
                print("Facebook login failed \(fberror)")
            }
           else
            {
                let accesstoken = FBSDKAccessToken.currentAccessToken().tokenString
                print("successfully logged in facebook \(accesstoken)")
                DataService.ds.REF_BASE.authWithOAuthProvider("facebook", token: accesstoken, withCompletionBlock: { error, authdata in
                    if error == nil
                    {
                        print("Login failed..! \(error)")
                    }
                    else
                    {
                        print("Logged in")
                        let user = ["provider": authdata.provider!]  //facebook provider
                        DataService.ds.createFirebaseUser(authdata.uid, users: user)
                        NSUserDefaults.standardUserDefaults().setValue(authdata.uid, forKey: KEY_UID)
                        self.performSegueWithIdentifier(Seque_loggedin, sender: nil)
                    }
                })
            }

        }
    }

}

