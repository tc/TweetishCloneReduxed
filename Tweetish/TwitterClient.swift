//
//  TwitterClient.swift
//  Shittr
//
//  Created by Patrick Stein on 9/10/15.
//  Copyright (c) 2015 patrick. All rights reserved.
//

import OAuthSwift
import Locksmith
import SwiftyJSON

class TwitterClient: NSObject {
    static let sharedInstance = TwitterClient()

    private static let consumerKey = "idD00emRQLmntEpTqYveTJNP2"
    private static let consumerSecret = "6kt9jb6aAEAyayrQJ2fz748Q37mEdjXCkTnndV7QHojQTQOBzX"
    //private static let consumerKey = "A1PafKo3iOplJQw6Xc5W7HmH7"
    //private static let consumerSecret = "tB6jHxf4aqhRmoFnjbNzER5BWDy0vPo4w8jZOgornDotNUdUz2"
    
    private static let baseUrl = "https://api.twitter.com"
    
    private var client: OAuthSwiftClient!
    
    var oauthToken: String!
    var oauthTokenSecret: String!
    
    override init() {
        super.init()
        
        let creds = Locksmith.loadDataForUserAccount("twitter")
        
        //NSLog(creds)
        
        if let creds = creds, token = creds["OAuthToken"] as? String, secret = creds["OAuthTokenSecret"] as? String {
            self.createClient(token, secret: secret)
        }
    }
    
    func hasCredentials() -> Bool {
        return client != nil
    }
    
    func loginWithCompletion(completion: (NSError? -> ())) {
        let oauth = OAuth1Swift(
            consumerKey: TwitterClient.consumerKey,
            consumerSecret: TwitterClient.consumerSecret,
            requestTokenUrl: TwitterClient.baseUrl + "/oauth/request_token",
            authorizeUrl: TwitterClient.baseUrl + "/oauth/authorize",
            accessTokenUrl: TwitterClient.baseUrl + "/oauth/access_token"
        )
        
        oauth.authorizeWithCallbackURL( NSURL(string: "oauth-swift://oauth-callback/twitter")!, success: {
            credential, response in
                        
            do {
                try Locksmith.updateData([
                    "OAuthToken": credential.oauth_token,
                    "OAuthTokenSecret": credential.oauth_token_secret
                    ], forUserAccount: "twitter")
                self.createClient(credential.oauth_token, secret: credential.oauth_token_secret)
                
            } catch {
                let error = NSError(domain: "TwitterClient", code: 1, userInfo: ["msg": "Can't update data"])
                NSLog("failed update locksmith")
                completion(error)
            }
            
            completion(nil)
            
            
            }, failure: {(error:NSError!) -> Void in
                NSLog("failure in oauth")
                NSLog(error.localizedDescription)
                completion(error)

            }
        )
    }
    
    func fetchUserInfo() {
        let params = Dictionary<String, AnyObject>()
        client.get(TwitterClient.baseUrl + "/1.1/account/verify_credentials.json", parameters: params, success: { (data, response) -> Void in
            let json = JSON(data: data)
            User.currentUser = User(json: json)
            
            NSLog("Finished fetchUserInfo")
            NSLog((User.currentUser?.screenName)!)

            
            }) { (error) -> Void in
                NSLog(error.description)
        }
    }

//    func fetchUser(screenName:String, completion: (user:User, error:NSError?) -> Void) {
//        let params:[String: String] = ["screen_name": screenName]
//        
//        client.get(TwitterClient.baseUrl + "/1.1/users/show.json", parameters: params, success: { (data, response) ->Void in
//
//            let json = JSON(data: data)
//            let user = User(json:json)
//            completion(user: user, error: nil)
//            
//            }) { (error) -> Void in
//                NSLog(error.description)
//                //completion(user: nil, error: error)
//        }
//    }

    func fetchHomeTweets(completion: (tweets:[Tweet], error:NSError?) -> Void) {
        let params:[String:String] = [:]
        
        fetchTweetsFromUrl(false, url: TwitterClient.baseUrl + "/1.1/statuses/home_timeline.json", params: params, completion: completion)
    }

    
    func fetchTweets(screenName:String, completion: (tweets:[Tweet], error:NSError?) -> Void) {
        let params = ["screen_name": screenName]
        
        fetchTweetsFromUrl(false, url: TwitterClient.baseUrl + "/1.1/statuses/user_timeline.json", params: params, completion: completion)
        
        //        var params:[String:AnyObject] = [:]
        //        params["max_id"] = tweet.id
        //
        //        fetchTweetsFromUrl(cached, url: "https://api.twitter.com/1.1/statuses/home_timeline.json", params: params, completion: completion)
    }

    private func fetchTweetsFromUrl(cached: Bool, url: String, params: [String:AnyObject]? = nil, completion: ([Tweet], NSError?) -> Void) {
        var params = params
        if params == nil {
            params = [String:AnyObject]()
        }
        
        client.get(url, parameters: params!, success: { (data, response) -> Void in
            var tweets: [Tweet] = []
            let json = JSON(data: data).array!
            for entry in json {
                tweets.append(Tweet(json: entry))
            }
            completion(tweets, nil)
            }, failure: { (error) -> Void in
                if error.code == 401 {
                    completion([], error) // TODO - Handle by reauthing?
                } else {
                    completion([], error)
                }
        })
    }
    
    func logout() {
        do {
            try Locksmith.deleteDataForUserAccount("twitter")
        } catch {
            NSLog("logout Fail")
        }
        
        client = nil
    }
    
    private func createClient(token: String, secret: String) {
        client = OAuthSwiftClient(
            consumerKey: TwitterClient.consumerKey,
            consumerSecret: TwitterClient.consumerSecret,
            accessToken: token,
            accessTokenSecret: secret
        )
        
        self.fetchUserInfo()
    }
}
