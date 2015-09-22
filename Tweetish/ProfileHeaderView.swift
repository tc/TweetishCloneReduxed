//
//  ProfileHeaderView.swift
//  Tweetish
//
//  Created by Tommy Chheng on 9/21/15.
//  Copyright © 2015 Tommy Chheng. All rights reserved.
//

import UIKit
import AFNetworking

class ProfileHeaderView: UIView {
    
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var userTitleLabel: UILabel!
    @IBOutlet weak var userAvatarImage: UIImageView!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    var user: User! {
        didSet {
            userHandleLabel.text = "@\(user.screenName!)"
            userTitleLabel.text = user.name
            bioLabel.text = user.tagline
            followingCountLabel.text = String(user.followingCount!)
            followersCountLabel.text = String(user.followersCount!)
            
            userAvatarImage.setImageWithURL(NSURL(string:user.avatarImageUrl!)!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}