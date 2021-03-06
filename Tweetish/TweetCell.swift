//
//  TweetCell.swift
//  Tweetish
//
//  Created by Bill Eager on 9/14/15.
//  Copyright (c) 2015 Bill Eager. All rights reserved.
//

import UIKit
import AFNetworking

protocol TweetCellDelegate {
    func onProfileTapped(tweet: Tweet, sender: AnyObject);
}

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var tweetContentLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var userTitleLabel: UILabel!
    @IBOutlet weak var userAvatarImage: UIImageView!
    @IBOutlet weak var replyImage: UIImageView!
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var favoriteImage: UIImageView!
    
    
    var tweet: Tweet! {
        didSet {
            tweetContentLabel.text = tweet.text
            userHandleLabel.text = "@\(tweet.user!.screenName!)"
            userTitleLabel.text = tweet.user?.name
            
            userAvatarImage.setImageWithURL(NSURL(string:tweet.avatarImageUrl!)!)
            
            timestampLabel.text = tweet.getCompactDate()
            if (tweet.favorited!) {
                favoriteImage.image = UIImage(named: "fav-on")
            } else {
                favoriteImage.image = UIImage(named: "fav-default")
            }
            if tweet.retweeted! {
                retweetImage.image = UIImage(named: "retweet-on")
            } else {
                retweetImage.image = UIImage(named: "retweet-default")
            }
            
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("avatarImageTapped:"))
            userAvatarImage.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    var delegate: TweetCellDelegate?
    
    func avatarImageTapped(sender: AnyObject) {
        NSLog("Single Tap on button")
        delegate?.onProfileTapped(tweet, sender: sender)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.layoutMargins = UIEdgeInsetsZero
        self.preservesSuperviewLayoutMargins = false
        tweetContentLabel.preferredMaxLayoutWidth = tweetContentLabel.frame.size.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layoutMargins = UIEdgeInsetsZero
        self.preservesSuperviewLayoutMargins = false
        tweetContentLabel.preferredMaxLayoutWidth = tweetContentLabel.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
