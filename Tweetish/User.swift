//
//  User.swift
//  Tweetish
//
//  Created by Bill Eager on 9/14/15.
//  Copyright (c) 2015 Bill Eager. All rights reserved.
//

import SwiftyJSON

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    static var currentUser:User?
    
    var name: String?
    var screenName: String?
    var avatarImageUrl: String?
    var tagline: String?
    var followingCount: Int?
    var followersCount: Int?
    
    var json: JSON?
    
    init(json: JSON) {
        self.json = json
        name = json["name"].string!
        screenName = json["screen_name"].string!

        followersCount = json["followers_count"].intValue
        followingCount = json["friends_count"].intValue
        
        avatarImageUrl = json["profile_image_url_https"].string!
        tagline = json["description"].string!
    }
}
