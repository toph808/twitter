//
//  ComposeViewController.swift
//  twitter
//
//  Created by Kris Aldenderfer on 5/24/15.
//  Copyright (c) 2015 Shopular. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
  
  var inReplyToId: String?
  var inReplyToUsername: String?
  
  @IBOutlet weak var tweetTextView: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationController!.navigationBar.barTintColor = UIColor(red: 0.31, green: 0.67, blue: 0.945, alpha: 1.0)
    self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
    
    self.navigationController!.navigationBar.barTintColor = UIColor(red: 0.33, green: 0.675, blue: 0.933, alpha: 1.0)
    
    if inReplyToUsername != nil {
      tweetTextView.text = "@\(inReplyToUsername!) "
    }
    
    self.tweetTextView.becomeFirstResponder()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func onComposeTweetButton(sender: AnyObject) {
    var tweetText = self.tweetTextView.text
    var params: Dictionary<String, AnyObject> = ["status": tweetText!]
    if inReplyToId != nil {
      params["in_reply_to_status_id"] = NSInteger(inReplyToId!.toInt()!)
      params["in_reply_to_status_id_str"] = inReplyToId!
    }
    
    TwitterClient.sharedInstance.tweetWithParams(params as NSDictionary, completion: { (status, error) -> () in
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
