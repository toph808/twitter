//
//  Tweet.swift
//  twitter
//
//  Created by Kris Aldenderfer on 5/24/15.
//  Copyright (c) 2015 Shopular. All rights reserved.
//

import UIKit

let userDidTweetNotification = "userDidTweetNotification"

class Tweet: NSObject {
  var user: User?
  var text: String?
  var createdAtString: String?
  var createdAt: NSDate?
  var dictionary: NSDictionary
  var retweetCount: NSInteger?
  var favoriteCount: NSInteger?
  var retweeted: Bool?
  var favorited: Bool?
  var id: String?
  
  init(dictionary: NSDictionary) {
    self.dictionary = dictionary
    user = User(dictionary: dictionary["user"] as! NSDictionary)
    text = dictionary["text"] as? String
    createdAtString = dictionary["created_at"] as? String
    retweetCount = dictionary["retweet_count"] as? NSInteger
    favoriteCount = dictionary["favorite_count"] as? NSInteger
    retweeted = dictionary["retweeted"] as? Bool
    favorited = dictionary["favorited"] as? Bool
    id = dictionary["id_str"] as? String
    
    // TODO: Make this formatter static and lazy
    var formatter = NSDateFormatter()
    formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
    createdAt = formatter.dateFromString(createdAtString!)
  }
  
  class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
    var tweets = [Tweet]()
    
    for dictionary in array {
      tweets.append(Tweet(dictionary: dictionary))
    }
    
    return tweets
  }
}
