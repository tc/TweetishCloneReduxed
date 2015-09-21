//
//  Tweet.swift
//  Tweetish
//
//  Created by Bill Eager on 9/14/15.
//  Copyright (c) 2015 Bill Eager. All rights reserved.
//

import UIKit
import SwiftyJSON

class Tweet: NSObject {
    
    var user: User?
    
    var avatarImageUrl:String?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var timestamp: String?
    var favoriteCount: Int?
    var retweetCount: Int?
    var favorited: Bool?
    var retweeted: Bool?
    var id: Int?
    
    var json: JSON
    
    init(json: JSON) {
        self.json = json
        user = User(json: json["user"])
        text = json["text"].string!
        createdAtString = json["created_at"].string!
        id = json["id"].intValue
        favoriteCount = json["favorite_count"].intValue
        retweetCount = json["retweet_count"].intValue
        favorited = json["favorited"].boolValue
        retweeted = json["retweeted"].boolValue
        avatarImageUrl = json["user"]["profile_image_url_https"].string!
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
    }
    
    func getCompactDate() -> String {
        if self.createdAt == nil {
            return ""
        }
        let units: NSCalendarUnit = [NSCalendarUnit.Minute, NSCalendarUnit.Hour, NSCalendarUnit.Day, NSCalendarUnit.Month]
        let components: NSDateComponents = NSCalendar.currentCalendar().components(units, fromDate: createdAt!, toDate: NSDate(), options: [])

        if (components.month > 0) {
            return "\(components.month)m"
        } else if (components.day > 0) {
            return "\(components.day)d"
        } else if (components.hour > 0) {
            return "\(components.hour)h"
        } else if (components.minute > 0) {
            return "\(components.minute)m"
        } else {
            return "Now"
        }
    }
}