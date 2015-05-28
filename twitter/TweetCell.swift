//
//  TweetCell.swift
//  twitter
//
//  Created by Kris Aldenderfer on 5/24/15.
//  Copyright (c) 2015 Shopular. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
  
  @IBOutlet weak var thumbImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var screennameLabel: UILabel!
  @IBOutlet weak var tweetTextLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var retweetCountLabel: UILabel!
  @IBOutlet weak var favoriteCountLabel: UILabel!
  @IBOutlet weak var retweetIcon: UIImageView!
  @IBOutlet weak var favoriteIcon: UIImageView!
  
  var tweet: Tweet! {
    didSet {
      nameLabel.text = tweet.user!.name
      screennameLabel.text = "@\(tweet.user!.screenname!)"
      tweetTextLabel.text = tweet.text
      timeLabel.text = tweet.createdAt!.timeAgo()
      thumbImageView.setImageWithURL(tweet.user!.profileImageUrl)
      retweetCountLabel.text = tweet.retweetCount?.description
      favoriteCountLabel.text = tweet.favoriteCount?.description
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    screennameLabel.preferredMaxLayoutWidth = screennameLabel.frame.size.width
    tweetTextLabel.preferredMaxLayoutWidth = tweetTextLabel.frame.size.width
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
  
}
