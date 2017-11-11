//
//  SparkWalkthroughManager.swift
//  WireMate
//
//  Created by Hubert  on 11.11.2017.
//  Copyright © 2017 Hubert Zajączkowski. All rights reserved.
//

import UIKit

@IBDesignable
class SparkWalkthroughManager: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate{
    
    @IBOutlet weak var controlSection: UIView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var notReadyButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    
    @IBInspectable var currentPageIndicatorTintColor: UIColor = UIColor.init(red: 64/255, green: 131/255, blue: 255/255, alpha: 1.0)
    @IBInspectable var pageIndicatorTintColor: UIColor = UIColor.init(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0)
    
    var pageVC: UIPageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    var pageControl: UIPageControl = UIPageControl()
    
    var pagesNumber: Int = 0
    
    var genericDataType: Dictionary<String, Array<String>> = Dictionary()
    
    override func viewDidLoad() {
        self.pagesNumber = 3
        
        self.pageVC.dataSource = self
        
        let viewControllersArray: Array<SparkWalkthroughContent> = [self.viewControllerAt(index: 0)!]
        
        self.pageVC.setViewControllers(viewControllersArray, direction: .forward, animated: false, completion: nil)
        
        self.addChildViewController(self.pageVC)
        
        self.pageVC.view.translatesAutoresizingMaskIntoConstraints = false
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.pageVC.view)
        self.view.addSubview(pageControl)
        
        self.pageVC.delegate = self
        
        let layoutViews = ["pageView": pageVC.view, "pageControl": pageControl, "controlSection": controlSection]
        var layoutConstraints = [NSLayoutConstraint]()
        
        let pageViewVerticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[pageView]-[controlSection]", options: [], metrics: nil, views: layoutViews)
        layoutConstraints += pageViewVerticalConstraint
        
        let pageViewHorizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[pageView]-0-|", options: [], metrics: nil, views: layoutViews)
        layoutConstraints += pageViewHorizontalConstraint
        
        NSLayoutConstraint(item: self.pageControl,
                           attribute: .width,
                           relatedBy: .equal,
                           toItem: self.pageVC.view,
                           attribute: .width,
                           multiplier: 0.1,
                           constant: 0).isActive = true
        
        NSLayoutConstraint(item: self.pageControl,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: self.pageVC.view,
                           attribute: .centerX,
                           multiplier: 1.0,
                           constant: 0).isActive = true
        
        NSLayoutConstraint(item: self.pageControl,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1.0,
                           constant: 10).isActive = true
        
        NSLayoutConstraint(item: self.pageControl,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: self.pageVC.view,
                           attribute: .bottom,
                           multiplier: 1.0,
                           constant: 0).isActive = true
        
        NSLayoutConstraint.activate(layoutConstraints)
        
        self.pageVC.didMove(toParentViewController: self)
        
        self.signUpButton.tag = 1
        self.logInButton.tag = 2
        
        self.setPageControl()
        self.setButton(sender: signUpButton)
        self.setButton(sender: logInButton)
        
        self.notReadyButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    //MARK: - UIPageViewControllerDataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentContentVC = viewController as! SparkWalkthroughContent
        
        var index = currentContentVC.pageIndex
        self.pageControl.currentPage = index
        
        if index == 0 || index == NSNotFound {
            return nil
        }
        
        index -= 1
        
        return viewControllerAt(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentContentVC = viewController as! SparkWalkthroughContent
        
        var index = currentContentVC.pageIndex
        self.pageControl.currentPage = index
        
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        
        if index == self.pagesNumber {
            return nil
        }
        
        return viewControllerAt(index: index)
    }
    
    //MARK: - UIPageViewControllerDelegate
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished {
        }
    }
    
    //MARK: - Utils
    func viewControllerAt(index: Int) -> SparkWalkthroughContent?{
        if self.pagesNumber == 0 || index >= self.pagesNumber {
            return nil
        }
        
        let currentContentVC = self.storyboard?.instantiateViewController(withIdentifier: "SparkWCVC") as! SparkWalkthroughContent
        currentContentVC.pageIndex = index
        
        let titleArray = genericDataType["titleArray"]
        let detailArray = genericDataType["detailArray"]
        
        currentContentVC.titleText = titleArray?[index]
        currentContentVC.detailText = detailArray?[index]
        
        return currentContentVC
    }
    
    func setPageControl() {
        self.pageControl.numberOfPages = self.pagesNumber
        self.pageControl.currentPage = 0
        
        self.pageControl.backgroundColor = UIColor.white
        self.pageControl.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor
        self.pageControl.pageIndicatorTintColor = self.pageIndicatorTintColor
    }
    
    func setButton(sender: UIButton) {
        sender.layer.cornerRadius = 5.0
        sender.clipsToBounds = true
        sender.layer.borderWidth = 1.0
        if sender.tag == 1 {
            sender.layer.borderColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.2).cgColor
            sender.backgroundColor = UIColor.init(red: 64/255, green: 131/255, blue: 255/255, alpha: 1.0)
        } else if sender.tag == 2 {
            sender.layer.borderColor = UIColor.init(red: 64/255, green: 131/255, blue: 255/255, alpha: 1.0).cgColor
        }
    }
}
