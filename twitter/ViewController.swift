//
//  ViewController.swift
//  twitter
//
//  Created by Kris Aldenderfer on 5/24/15.
//  Copyright (c) 2015 Shopular. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var loginButton: UIButton!
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func onLoginButton(sender: AnyObject) {
    TwitterClient.sharedInstance.loginWithCompletion() {
      (user: User?, error: NSError?) in
      if user != nil {
        self.performSegueWithIdentifier("loginSegue", sender: self)
      } else {
        // handle login error
      }
    }
  }

}

