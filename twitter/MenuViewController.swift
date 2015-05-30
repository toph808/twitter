//
//  MenuViewController.swift
//  twitter
//
//  Created by Kris Aldenderfer on 5/29/15.
//  Copyright (c) 2015 Shopular. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
  
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var hamburgerMenuView: UIView!
  @IBOutlet weak var profileButton: UIButton!
  @IBOutlet weak var timelineButton: UIButton!
  @IBOutlet weak var mentionsButton: UIButton!
  
  @IBOutlet weak var leftConstraint: NSLayoutConstraint!
  
  var viewControllers = [UIViewController]()
  var activeViewController: UIViewController? {
    didSet(oldViewControllerOrNil) {
      if let oldVC = oldViewControllerOrNil {
        oldVC.willMoveToParentViewController(nil)
        oldVC.view.removeFromSuperview()
        oldVC.removeFromParentViewController()
      }
      if let newVC = activeViewController {
        self.addChildViewController(newVC)
        newVC.view.frame = self.contentView.bounds
        self.contentView.addSubview(newVC.view)
        newVC.didMoveToParentViewController(self)
        self.contentView.bringSubviewToFront(hamburgerMenuView)
        self.leftConstraint.constant = -130
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    var timelineNav = storyboard?.instantiateViewControllerWithIdentifier("TweetsNavigationController") as! UINavigationController
    var mentionsNav = storyboard?.instantiateViewControllerWithIdentifier("TweetsNavigationController") as! UINavigationController
    
    // Pass data to timeline/mentions VCs
    var timelineVC = timelineNav.viewControllers[0] as! TweetsViewController
    timelineVC.timelineType = "home"
    
    var mentionsVC = mentionsNav.viewControllers[0] as! TweetsViewController
    mentionsVC.timelineType = "mentions"
    
    self.activeViewController = timelineNav
    self.viewControllers = [timelineNav, mentionsNav]
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func onProfileButton(sender: AnyObject) {
  }
  
  @IBAction func onTimelineButton(sender: AnyObject) {
    activeViewController = viewControllers[0]
  }
  
  @IBAction func onMentionsButton(sender: AnyObject) {
    activeViewController = viewControllers[1]
  }
  
  @IBAction func onSwipeRight(sender: UISwipeGestureRecognizer) {
    UIView.animateWithDuration(0.2, animations: { () -> Void in
      self.leftConstraint.constant = 0
      self.view.layoutIfNeeded()
    })
  }
  
  @IBAction func onSwipeLeft(sender: UISwipeGestureRecognizer) {
    UIView.animateWithDuration(0.2, animations: { () -> Void in
      self.leftConstraint.constant = -130
      self.view.layoutIfNeeded()
    })
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
