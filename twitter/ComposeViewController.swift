//
//  ComposeViewController.swift
//  twitter
//
//  Created by Kris Aldenderfer on 5/24/15.
//  Copyright (c) 2015 Shopular. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
  
  @IBOutlet weak var tweetTextView: UITextView!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func onComposeTweetButton(sender: AnyObject) {
    var tweetText = self.tweetTextView.text
    var params: NSDictionary = ["status": tweetText]
    
    TwitterClient.sharedInstance.tweetWithParams(params, completion: { (status, error) -> () in
      if error != nil {
        NSLog("Failed to tweet: \(error)")
        return
      }
      NSNotificationCenter.defaultCenter().postNotificationName(userDidTweetNotification, object: status)
      self.dismissViewControllerAnimated(true, completion: nil)
    })
  }
  
  @IBAction func onBack(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
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
