//
//  TimelineViewController.swift
//  Tweetish
//
//  Created by Bill Eager on 9/14/15.
//  Copyright (c) 2015 Bill Eager. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var timelineTweets: [Tweet]?
    var user: User?
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        NSLog("TimelineViewController viewDidLoad")
        
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = false
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 220
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Add refresh control to the tableView
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh...", attributes: [NSForegroundColorAttributeName: UIColor.orangeColor()])
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex:0)

        title = "Timeline"
        loadData()
        // Do any additional setup after loading the view.
    }
    
    func loadData() {
        if let u = user {
            TwitterClient.sharedInstance.fetchTweets(u.screenName!, completion: {(tweets, error) in
                self.timelineTweets = tweets
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            })
        } else {
            TwitterClient.sharedInstance.fetchHomeTweets({(tweets, error) in
                self.timelineTweets = tweets
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            })
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // When refresh is triggered, change the title and load the data
    func onRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Loading data...", attributes: [NSForegroundColorAttributeName: UIColor.orangeColor()])
        loadData()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if timelineTweets != nil {
            return timelineTweets!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.registerNib(UINib(nibName: "TweetCell", bundle: nil), forCellReuseIdentifier: "TweetCell")
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as? TweetCell

        if let c = cell {
            c.tweet = timelineTweets![indexPath.row]
            c.layoutIfNeeded()
            return c
        } else {
            // should never get here..
            return UITableViewCell()
        }
    }
        
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("TimelineViewController#didSelectRowAtIndexPath")

        let tweet = timelineTweets![indexPath.row]
        pushProfileView(tweet)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // MARK: - Navigation
    
    func pushProfileView(tweet:Tweet) {
        let identifier = "ProfileViewController"
        let profileViewController = navigationController?.storyboard?.instantiateViewControllerWithIdentifier(identifier) as! ProfileViewController
        profileViewController.user = tweet.user
        navigationController?.pushViewController(profileViewController, animated: true)
    }

    func pushTweetView(tweet:Tweet) {
        let identifier = "TweetViewController"
        let tweetViewController = navigationController?.storyboard?.instantiateViewControllerWithIdentifier(identifier) as! TweetViewController
        tweetViewController.tweet = tweet
        navigationController?.pushViewController(tweetViewController, animated: true)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        NSLog("TimelineViewController#prepareForSegue")

        switch(segue.identifier!) {
            case "viewTweetSegue":
                let tweetViewController = segue.destinationViewController as! TweetViewController
                let cell = sender as! UITableViewCell
                let indexPath = tableView.indexPathForCell(cell)
                let tweet = timelineTweets![indexPath!.row]
                tweetViewController.tweet = tweet
            break
            
            case "viewProfileSegue":
                let profileViewController = segue.destinationViewController as! ProfileViewController
                let cell = sender as! UITableViewCell
                let indexPath = tableView.indexPathForCell(cell)
                let tweet = timelineTweets![indexPath!.row]
                profileViewController.user = tweet.user
            
            break
        default:
            break
        }
    }
}
