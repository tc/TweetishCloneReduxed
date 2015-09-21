//
//  TweetViewController.swift
//  Tweetish
//
//  Created by Bill Eager on 9/14/15.
//  Copyright (c) 2015 Bill Eager. All rights reserved.
//

import UIKit
import AFNetworking

@objc protocol TweetViewControllerDelegate {
    optional func tweetViewController(tweetViewController: TweetViewController, didFavoriteTweet success: Bool)
    optional func tweetViewController(tweetViewController: TweetViewController, didRetweetTweet success: Bool)
}

class TweetViewController: UIViewController {

    @IBOutlet weak var favImage: UIImageView!
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var replyImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.setImageWithURL(NSURL(string:tweet!.avatarImageUrl!)!)
        userNameLabel.text = tweet?.user?.name
        userHandleLabel.text = "@\((tweet?.user?.screenName)!)"
        tweetLabel.text = tweet?.text
        dateLabel.text = tweet?.createdAtString
        retweetCountLabel.text = "\((tweet?.retweetCount)!)"
        favoriteCountLabel.text = "\((tweet?.favoriteCount)!)"
        
        // Do any additional setup after loading the view.
        
        if tweet!.favorited! {
            favImage.image = UIImage(named: "fav-on")
            favImage.userInteractionEnabled = false
        }
        if tweet!.retweeted! {
            retweetImage.image = UIImage(named: "retweet-on")
            retweetImage.userInteractionEnabled = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
}
