//
//  TwitterClient.swift
//  twitter
//
//  Created by Kris Aldenderfer on 5/24/15.
//  Copyright (c) 2015 Shopular. All rights reserved.
//

import UIKit

let twitterConsumerKey = "BIjMmHbXBQnzaFveKoaHsv7sb"
let twitterConsumerSecret = "bMjrPOYh7h8VynIqEfLRYTJbxF16i0sRjWmt2Kwvbqw5vRRHmP"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
  
  var loginCompletion: ((user: User?, error: NSError?) -> ())?
  
  class var sharedInstance: TwitterClient {
    struct Static {
      static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
    }
    
    return Static.instance
  }
  
  func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
    loginCompletion = completion
    
    // Fetch request token & redirect to authorization page.
    TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
    TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
      var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
      UIApplication.sharedApplication().openURL(authURL)
    }) { (error: NSError!) -> Void in
      println(error)
      self.loginCompletion?(user: nil, error: error)
    }
  }
  
  func fetchTimelineWithParams(params: NSDictionary?, forTimelineType: String, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
    GET("1.1/statuses/\(forTimelineType)_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
      var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
      completion(tweets: tweets, error: nil)
    }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
      completion(tweets: nil, error: error)
    })
  }
  
  func fetchProfileBannerWithParams(params: NSDictionary?, completion: (sizes: NSDictionary?, error: NSError?) -> ()) {
    GET("1.1/users/profile_banner.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
      var sizes = response as! NSDictionary
      completion(sizes: sizes, error: nil)
      }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
        completion(sizes: nil, error: error)
    })
  }
  
  func tweetWithParams(params: NSDictionary?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
    POST("1.1/statuses/update.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
      var tweet = Tweet(dictionary: response as! NSDictionary)
      completion(tweet: tweet, error: nil)
    }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
      completion(tweet: nil, error: error)
    })
  }
  
  func retweetWithParams(params: NSDictionary?, tweetId: String, completion: (tweet: Tweet?, error: NSError?) -> ()) {
    POST("1.1/statuses/retweet/\(tweetId).json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
      var tweet = Tweet(dictionary: response as! NSDictionary)
      completion(tweet: tweet, error: nil)
    }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
      completion(tweet: nil, error: error)
    })
  }
  
  func favoriteWithParams(params: NSDictionary?, tweetId: String, completion: (tweet: Tweet?, error: NSError?) -> ()) {
    POST("1.1/favorites/create.json?id=\(tweetId)", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
      var tweet = Tweet(dictionary: response as! NSDictionary)
      completion(tweet: tweet, error: nil)
    }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
      completion(tweet: nil, error: error)
    })
  }
  
  func openURL(url: NSURL) {
    fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
      TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
      TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
        // println("Current user: \(response)")
        var user = User(dictionary: response as! NSDictionary)
        User.currentUser = user
        println("user: \(user.name)")
        self.loginCompletion?(user: user, error: nil)
      }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
        println(error)
        self.loginCompletion?(user: nil, error: error)
      })
    }) { (error: NSError!) -> Void in
      println("Failed to receive access token")
      self.loginCompletion?(user: nil, error: error)
    }

  }
  
}
