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
  var inReplyToId: String?
  var inReplyToUsername: String?
  var currentUser: User?
  var isLoading = false
  
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
    
    refreshData()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    refreshData()
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var numberOfRowsInSection = self.tweets?.count ?? 0
    return numberOfRowsInSection + 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if indexPath.row == 0 {
      let cell = self.tableView.dequeueReusableCellWithIdentifier("ProfileCell") as! ProfileCell
      cell.currentUser = currentUser
      
      var params = ["screen_name": self.currentUser!.screenname!] as NSDictionary
      TwitterClient.sharedInstance.fetchProfileBannerWithParams(params, completion: { (sizes, error) -> () in
        var url = NSURL(string: sizes?.valueForKeyPath("sizes.600x200.url") as! String)
        cell.profileBannerImageView.setImageWithURL(url!)
      })
      
      return cell
    } else {
      let cell = self.tableView.dequeueReusableCellWithIdentifier("TweetCell") as! TweetCell
      cell.delegate = self
      cell.tweet = self.tweets?[indexPath.row]
      
      if (indexPath.row == self.tweets!.count - 1 && isLoading == false) {
        isLoading = true
        var params = ["max_id": cell.tweet.id!, "screen_name": self.currentUser!.screenname!] as NSDictionary
        
        TwitterClient.sharedInstance.fetchTimelineWithParams(params, forTimelineType: "user", completion: { (tweets, error) -> () in
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
  }
  
  func refreshData() {
    var params = ["screen_name": self.currentUser!.screenname!] as NSDictionary
    TwitterClient.sharedInstance.fetchTimelineWithParams(params, forTimelineType: "user", completion: { (tweets, error) -> () in
      self.tweets = tweets
      
      if self.refreshControl.refreshing {
        self.refreshControl.endRefreshing()
      }
      
      self.tableView.reloadData()
    })
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func onComposeButton(sender: AnyObject) {
    inReplyToId = nil
    inReplyToUsername = nil
    self.performSegueWithIdentifier("ComposeSegue", sender: self)
  }
  
  func didReply(tweet: Tweet) {
    inReplyToId = tweet.id
    inReplyToUsername = tweet.user!.screenname
    self.performSegueWithIdentifier("ComposeSegue", sender: self)
  }
  
  func didRetweet(tweet: Tweet, tweetCell: TweetCell?) {
    tweet.retweetCount! += NSInteger(1)
    tweet.retweeted = true
    tableView.reloadData()
  }
  
  func didFavorite(tweet: Tweet, tweetCell: TweetCell?) {
    tweet.favoriteCount! += NSInteger(1)
    tweet.favorited = true
    tableView.reloadData()
  }
  
  @IBAction func onLogout(sender: AnyObject) {
    User.currentUser?.logout()
  }
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "SingleTweetSegue" {
      let cell = sender as! TweetCell
      let tweet = cell.tweet
      
      var nav = segue.destinationViewController as! UINavigationController
      var vc = nav.topViewController as! SingleTweetViewController
      vc.tweet = tweet
      vc.delegate = self
    } else if segue.identifier == "ComposeSegue" {
      var nav = segue.destinationViewController as! UINavigationController
      var vc = nav.topViewController as! ComposeViewController
      vc.inReplyToId = inReplyToId
      if (inReplyToUsername != nil) {
        vc.inReplyToUsername = inReplyToUsername!
      }
    }
  }
  
}
