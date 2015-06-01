//
//  TweetCell.swift
//  twitter
//
//  Created by Kris Aldenderfer on 5/24/15.
//  Copyright (c) 2015 Shopular. All rights reserved.
//

import UIKit

@objc protocol TweetDelegate {
  optional func didRetweet(tweet: Tweet, tweetCell: TweetCell?)
  optional func didFavorite(tweet: Tweet, tweetCell: TweetCell?)
  optional func didReply(tweet: Tweet)
  optional func didTapThumb(user: User)
}

class TweetCell: UITableViewCell {
  
  @IBOutlet weak var thumbImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var screennameLabel: UILabel!
  @IBOutlet weak var tweetTextLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var retweetCountLabel: UILabel!
  @IBOutlet weak var favoriteCountLabel: UILabel!
  
  @IBOutlet weak var replyIcon: UIImageView!
  @IBOutlet weak var retweetIcon: UIImageView!
  @IBOutlet weak var favoriteIcon: UIImageView!
  
  weak var delegate: TweetDelegate?
  
  var tweet: Tweet! {
    didSet {
      nameLabel.text = tweet.user!.name
      screennameLabel.text = "@\(tweet.user!.screenname!)"
      tweetTextLabel.text = tweet.text
      timeLabel.text = tweet.createdAt!.timeAgo()
      thumbImageView.setImageWithURL(tweet.user!.profileImageUrl)
      retweetCountLabel.text = tweet.retweetCount?.description
      favoriteCountLabel.text = tweet.favoriteCount?.description
      retweetIcon.image = tweet.retweeted ?? false ? UIImage(named: "retweet_on") : UIImage(named: "retweet")
      favoriteIcon.image = tweet.favorited ?? false ? UIImage(named: "favorite_on") : UIImage(named: "favorite")
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    screennameLabel.preferredMaxLayoutWidth = screennameLabel.frame.size.width
    tweetTextLabel.preferredMaxLayoutWidth = tweetTextLabel.frame.size.width
    
    replyIcon.userInteractionEnabled = true
    retweetIcon.userInteractionEnabled = true
    favoriteIcon.userInteractionEnabled = true
    thumbImageView.userInteractionEnabled = true
    
    var replyTap = UITapGestureRecognizer(target: self, action:Selector("onReply:"))
    replyIcon.addGestureRecognizer(replyTap)
    var retweetTap = UITapGestureRecognizer(target: self, action:Selector("onRetweet:"))
    retweetIcon.addGestureRecognizer(retweetTap)
    var favoriteTap = UITapGestureRecognizer(target: self, action:Selector("onFavorite:"))
    favoriteIcon.addGestureRecognizer(favoriteTap)
    var thumbTap = UITapGestureRecognizer(target: self, action:Selector("onThumbTap:"))
    thumbImageView.addGestureRecognizer(thumbTap)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    screennameLabel.preferredMaxLayoutWidth = screennameLabel.frame.size.width
    tweetTextLabel.preferredMaxLayoutWidth = tweetTextLabel.frame.size.width
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func onReply(recognizer: UITapGestureRecognizer) {
    delegate?.didReply?(self.tweet)
  }
  
  func onRetweet(recognizer: UITapGestureRecognizer) {
    var tweetId = self.tweet.id
    
    TwitterClient.sharedInstance.retweetWithParams(nil, tweetId: tweetId!, completion: { (tweet, error) -> () in
      if error != nil {
        NSLog("Failed to retweet: \(error)")
      } else {
        self.delegate?.didRetweet?(self.tweet, tweetCell: self)
      }
    })
  }
  
  func onFavorite(recognizer: UITapGestureRecognizer) {
    var tweetId = self.tweet.id
    
    TwitterClient.sharedInstance.favoriteWithParams(nil, tweetId: tweetId!, completion: { (tweet, error) -> () in
      if error != nil {
        NSLog("Failed to favorite: \(error)")
      } else {
        self.delegate?.didFavorite?(self.tweet, tweetCell: self)
      }
    })
  }
  
  func onThumbTap(recognizer: UITapGestureRecognizer) {
    println("tapped")
    var user = self.tweet.user!
    self.delegate?.didTapThumb?(user)
  }
  
}
