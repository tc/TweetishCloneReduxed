//
//  ProfileViewController.swift
//  Tweetish
//
//  Created by Tommy Chheng on 9/20/15.
//  Copyright © 2015 Tommy Chheng. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var user:User?
    var timelineTweets: [Tweet]?
    
    var refreshControl: UIRefreshControl!
    var profileHeaderView: ProfileHeaderView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = false

        profileHeaderView = NSBundle.mainBundle().loadNibNamed("ProfileHeaderView", owner: self, options: nil)[0] as! ProfileHeaderView

        profileHeaderView?.user = user
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 220
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableHeaderView = profileHeaderView
        
        // Add refresh control to the tableView
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh...", attributes: [NSForegroundColorAttributeName: UIColor.orangeColor()])
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex:0)
        
        if let u = user {
            title = u.screenName
        }
        
        sizeHeaderToFit()

        loadData()
    }
    
    // http://stackoverflow.com/questions/19005446/table-header-view-height-is-wrong-when-using-auto-layout-ib-and-font-sizes
    func sizeHeaderToFit() {
        let header = self.tableView.tableHeaderView
        
        header?.setNeedsLayout()
        header?.layoutIfNeeded()
        
        let height = header?.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        var frame = header?.frame
        
        frame?.size.height = height!
        header!.frame = frame!
        
        self.tableView.tableHeaderView = header
    }
    
    func loadData() {
        if let u = user {
            TwitterClient.sharedInstance.fetchTweets(u.screenName!, completion: {(tweets, error) in
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
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
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
    
    // Deselect active row on tap
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Navigation
    
}
