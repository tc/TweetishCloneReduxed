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
    var name: String?
    var screenName: String?
    var profileImageUrl: String?
    var tagline: String?
    var json: JSON?
    
    init(json: JSON) {
        self.json = json
        name = json["name"].string!
        screenName = json["screen_name"].string!
        profileImageUrl = json["profile_image_url"].string!
        tagline = json["description"].string!
    }
    
    func logout() {
        //User.currentUser = nil
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
}
