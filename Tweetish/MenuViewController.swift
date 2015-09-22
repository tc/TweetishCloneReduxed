//
//  MenuViewController.swift
//  Tweetish
//
//  Created by Tommy Chheng on 9/21/15.
//  Copyright © 2015 Bill Eager. All rights reserved.
//


import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    private var blueNavigationController: UIViewController!
    
    private var twitterLoginViewController: UIViewController!
    private var profileViewController: UIViewController!
    private var timelineNavigationController: UIViewController!
    
    var viewControllers: [UIViewController] = []
    
    var hamburgerViewController: HamburgerContainerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        twitterLoginViewController = storyboard.instantiateViewControllerWithIdentifier("TwitterLoginViewController")
        profileViewController = storyboard.instantiateViewControllerWithIdentifier("ProfileViewController")
        timelineNavigationController = storyboard.instantiateViewControllerWithIdentifier("TimelineNavigationController")
        

        blueNavigationController = storyboard.instantiateViewControllerWithIdentifier("BlueNavigationController")
        
        viewControllers.append(blueNavigationController)
        viewControllers.append(twitterLoginViewController)
        viewControllers.append(profileViewController)
        viewControllers.append(timelineNavigationController)
        
        hamburgerViewController?.contentViewController = blueNavigationController
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HamburgerMenuCell", forIndexPath: indexPath) as! HamburgerMenuCell
        
        let titles = ["Login", "Me", "Timeline", "Blue"]
        cell.menuTitleLabel.text = titles[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        hamburgerViewController?.contentViewController = viewControllers[indexPath.row]
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
