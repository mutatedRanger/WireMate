//
//  SplashScreenViewController.swift
//  WireMate
//
//  Created by Hubert  on 11.11.2017.
//  Copyright © 2017 Hubert Zajączkowski. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var logoImage: UIImageView!
    
    var pulsing: PulsingAnimation = PulsingAnimation()
    var customTransition = FadeInOutAnimationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setPulsingAnimation()
        self.view.layer.insertSublayer(pulsing, below: logoImage.layer)
        
        self.setNextButton()
        
        self.navigationController?.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillResignActive(_:)), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillEnterForeground(_:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didChangePrefferedContentSize(_:)), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNextButton() {
        nextButton.layer.cornerRadius = 5.0
        nextButton.clipsToBounds = true
        nextButton.layer.borderWidth = 1.0
        nextButton.layer.borderColor = UIColor.init(red: 64/255, green: 131/255, blue: 255/255, alpha: 1.0).cgColor
    }

    func setPulsingAnimation() {
        let _radius: CGFloat = (100 + 10) * (logoImage.bounds.size.height / 100)
        
        self.pulsing.backgroundColor = UIColor.init(red: 64/255, green: 131/255, blue: 255/255, alpha: 1.0).cgColor
        self.pulsing.radius = _radius
        self.pulsing.position = logoImage.center
    }
    
    @objc func applicationWillResignActive(_ notification: Notification) {
        self.pulsing.removeFromSuperlayer()
    }
    
    @objc func applicationWillEnterForeground(_ notification: Notification) {
        self.pulsing.addAnimationToTree()
        self.view.layer.insertSublayer(self.pulsing, below: logoImage.layer)
    }
    
    @objc func didChangePrefferedContentSize(_ notification: Notification) {
        //This function handles fonts' changes according to iPhone's scale-up.
    }
    
    @IBAction func tappedNextButton(_ sender: UIButton) {
        pulsing.removeFromSuperlayer()
        //let walkthrough = self.storyboard?.instantiateViewController(withIdentifier: "WalkthroughVC") as! SparkWalkthroughManager
        
        //self.navigationController?.pushViewController(walkthrough, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SplashScreenViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customTransition
    }
}
