//
//  TweetsViewController.swift
//  twitter
//
//  Created by Kris Aldenderfer on 5/24/15.
//  Copyright (c) 2015 Shopular. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TweetDelegate {
  
  var tweets: [Tweet]?
  var inReplyToId: String?
  var inReplyToUsername: String?
  var isLoading = false
  
  @IBOutlet weak var tableView: UITableView!
  var refreshControl: UIRefreshControl!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.refreshControl = UIRefreshControl()
    self.refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
    self.tableView.insertSubview(self.refreshControl, atIndex: 0)
    
    self.tableView.dataSource = self
    self.tableView.delegate = self
    self.tableView.rowHeight = UITableViewAutomaticDimension
    self.tableView.estimatedRowHeight = 120
    
    TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
      if error != nil {
        println(error)
        UIAlertView(title: "Error!", message: "Request failed - probably don't fire so many requests?", delegate: nil, cancelButtonTitle: "OK").show()
      }
      self.tweets = tweets
      self.tableView.reloadData()
    })
  }
  
  override func viewDidAppear(animated: Bool) {
    self.tableView.reloadData()
  }
  
  func refreshData() {
    TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
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
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.tweets?.count ?? 0
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = self.tableView.dequeueReusableCellWithIdentifier("TweetCell") as! TweetCell
    cell.delegate = self
    cell.tweet = self.tweets?[indexPath.row]
    
    if (indexPath.row == self.tweets!.count - 1 && isLoading == false) {
      isLoading = true
      var params = ["max_id": cell.tweet.id!] as NSDictionary
      
      TwitterClient.sharedInstance.homeTimelineWithParams(params, completion: { (tweets, error) -> () in
        if error != nil {
          println(error)
          UIAlertView(title: "Error!", message: "Request failed - probably don't fire so many requests?", delegate: nil, cancelButtonTitle: "OK").show()
        }
        self.tweets = tweets
        self.tableView.reloadData()
        
        self.isLoading = false
      })
    }
    
    return cell
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
