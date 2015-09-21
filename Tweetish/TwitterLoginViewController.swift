//
//  TwitterLoginViewController.swift
//  Tweetish
//
//  Created by Bill Eager on 9/14/15.
//  Copyright (c) 2015 Bill Eager. All rights reserved.
//

import UIKit

class TwitterLoginViewController: UIViewController {

    @IBAction func onLogin(sender: AnyObject) {
        TwitterClient.sharedInstance.loginWithCompletion { (error) -> () in
            
            if let error = error {
                NSLog("Error logging in: \(error.description)")
                UIAlertView(title: "Login Error", message: "Could not login", delegate: nil, cancelButtonTitle: "ok").show()
                
            } else {
                self.performSegueWithIdentifier("loginSegue", sender: self)
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        if (TwitterClient.sharedInstance.hasCredentials()) {
            print("Has creds")
            self.performSegueWithIdentifier("loginSegue", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
