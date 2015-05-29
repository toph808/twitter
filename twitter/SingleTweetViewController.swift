//
//  SingleTweetViewController.swift
//  twitter
//
//  Created by Kris Aldenderfer on 5/24/15.
//  Copyright (c) 2015 Shopular. All rights reserved.
//

import UIKit

class SingleTweetViewController: UIViewController {
  
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var screennameLabel: UILabel!
  @IBOutlet weak var tweetTextLabel: UILabel!
  @IBOutlet weak var retweetCountLabel: UILabel!
  @IBOutlet weak var favoriteCountLabel: UILabel!
  
  @IBOutlet weak var replyIcon: UIImageView!
  @IBOutlet weak var retweetIcon: UIImageView!
  @IBOutlet weak var favoriteIcon: UIImageView!
  
  weak var delegate: TweetDelegate?
  
  var tweet: Tweet!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    nameLabel.text = tweet.user!.name
    screennameLabel.text = "@\(tweet.user!.screenname!)"
    tweetTextLabel.text = tweet.text
    retweetCountLabel.text = tweet.retweetCount?.description
    favoriteCountLabel.text = tweet.favoriteCount?.description
    profileImageView.setImageWithURL(tweet.user!.profileImageUrl)
    
    retweetIcon.image = tweet.retweeted ?? false ? UIImage(named: "retweet_on") : UIImage(named: "retweet")
    favoriteIcon.image = tweet.favorited ?? false ? UIImage(named: "favorite_on") : UIImage(named: "favorite")
    
    replyIcon.userInteractionEnabled = true
    retweetIcon.userInteractionEnabled = true
    favoriteIcon.userInteractionEnabled = true
    
    var replyTap = UITapGestureRecognizer(target: self, action:Selector("onReply:"))
    replyIcon.addGestureRecognizer(replyTap)
    var retweetTap = UITapGestureRecognizer(target: self, action:Selector("onRetweet:"))
    retweetIcon.addGestureRecognizer(retweetTap)
    var favoriteTap = UITapGestureRecognizer(target: self, action:Selector("onFavorite:"))
    favoriteIcon.addGestureRecognizer(favoriteTap)
  }
  
  func onReply(recognizer: UITapGestureRecognizer) {
    self.performSegueWithIdentifier("ReplySegue", sender: self)
  }
  
  func onRetweet(recognizer: UITapGestureRecognizer) {
    var tweetId = self.tweet.id
    
    TwitterClient.sharedInstance.retweetWithParams(nil, tweetId: tweetId!, completion: { (tweet, error) -> () in
      if error != nil {
        NSLog("Failed to retweet: \(error)")
      } else {
        self.delegate?.didRetweet?(self.tweet, tweetCell: nil)
        self.retweetIcon.image = UIImage(named: "retweet_on")
        self.retweetCountLabel.text = self.tweet.retweetCount!.description
      }
    })
  }
  
  func onFavorite(recognizer: UITapGestureRecognizer) {
    var tweetId = self.tweet.id
    
    TwitterClient.sharedInstance.favoriteWithParams(nil, tweetId: tweetId!, completion: { (tweet, error) -> () in
      if error != nil {
        NSLog("Failed to favorite: \(error)")
      } else {
        self.delegate?.didFavorite?(self.tweet, tweetCell: nil)
        self.favoriteIcon.image = UIImage(named: "favorite_on")
        self.favoriteCountLabel.text = self.tweet.favoriteCount!.description
      }
    })
  }
  
  @IBAction func onBack(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
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
