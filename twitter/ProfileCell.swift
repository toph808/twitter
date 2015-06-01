//
//  ProfileCell.swift
//  twitter
//
//  Created by Kris Aldenderfer on 5/31/15.
//  Copyright (c) 2015 Shopular. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {
  
  @IBOutlet weak var bannerImageView: UIImageView!
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var profileBannerImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var screennameLabel: UILabel!
  @IBOutlet weak var tweetsCountLabel: UILabel!
  @IBOutlet weak var followingCountLabel: UILabel!
  @IBOutlet weak var followersCountLabel: UILabel!
  
  var currentUser: User! {
    didSet {
      nameLabel.text = currentUser.name
      screennameLabel.text = "@\(currentUser.screenname!)"
      profileImageView.setImageWithURL(currentUser.profileImageUrl)
      tweetsCountLabel.text = currentUser.tweetCount?.description
      followingCountLabel.text = currentUser.followingCount?.description
      followersCountLabel.text = currentUser.followerCount?.description
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  
  

  
}
