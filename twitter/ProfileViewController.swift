//
//  ProfileViewController.swift
//  twitter
//
//  Created by Kris Aldenderfer on 5/31/15.
//  Copyright (c) 2015 Shopular. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TweetDelegate {
  
  var tweets: [Tweet]?
  var currentUser: User?
  var isLoading = false
  var timelineType: String?
  
  var refreshControl: UIRefreshControl!
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.currentUser = self.currentUser ?? User.currentUser
    
    self.navigationController!.navigationBar.barTintColor = UIColor(red: 0.31, green: 0.67, blue: 0.945, alpha: 1.0)
    self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
    
    self.refreshControl = UIRefreshControl()
    self.refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
    self.tableView.insertSubview(self.refreshControl, atIndex: 0)
    
    self.tableView.dataSource = self
    self.tableView.delegate = self
    self.tableView.rowHeight = UITableViewAutomaticDimension
    self.tableView.estimatedRowHeight = 120
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var numberOfRowsInSection = self.tweets?.count ?? 0
    return numberOfRowsInSection + 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = self.tableView.dequeueReusableCellWithIdentifier("TweetCell") as! TweetCell
    cell.delegate = self
    cell.tweet = self.tweets?[indexPath.row]
    
    if (indexPath.row == self.tweets!.count - 1 && isLoading == false) {
      isLoading = true
      var params = ["max_id": cell.tweet.id!] as NSDictionary
      
      TwitterClient.sharedInstance.fetchTimelineWithParams(params, forTimelineType: timelineType!, completion: { (tweets, error) -> () in
        if error != nil {
          println(error)
          UIAlertView(title: "Error!", message: "Request failed - probably don't fire so many requests?", delegate: nil, cancelButtonTitle: "OK").show()
        } else {
          self.tweets = self.tweets! + tweets!
        }
        self.tableView.reloadData()
        
        self.isLoading = false
      })
    }
    
    return cell
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
