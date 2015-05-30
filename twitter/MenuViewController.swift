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
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    var timelineVC = storyboard?.instantiateViewControllerWithIdentifier("TweetsNavigationController") as! UINavigationController
    var mentionsVC = storyboard?.instantiateViewControllerWithIdentifier("TweetsNavigationController") as! UINavigationController
    
    self.activeViewController = timelineVC
    
    self.viewControllers = [timelineVC, mentionsVC]
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
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
}
