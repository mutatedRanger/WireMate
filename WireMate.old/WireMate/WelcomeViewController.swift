//
//  WelcomeViewController.swift
//  WireMate
//
//  Created by Hubert on 08.08.2017.
//  Copyright © 2017 Sidereum. All rights reserved.
//

import UIKit
import ZCAnimatedLabel

class WelcomeViewController: UIViewController, ZCAnimatedLabelDelegate{

    var animatedLabel: ZCFocusLabel!
    var animatedLabelS: ZCFocusLabel!
    var nametoDisplay: String?
    
    @IBOutlet weak var exploreButton: UIButton!
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureExploreButton()
        
        self.animatedLabel = ZCFocusLabel(frame: helloLabel.frame)
        self.animatedLabelS = ZCFocusLabel(frame: welcomeLabel.frame)
        
        self.view.addSubview(self.animatedLabel)
        self.view.addSubview(self.animatedLabelS)
        
        animatedLabelS.delegate = self
        
        let textToAttach = nametoDisplay ?? "User"
        
        self.helloLabel.text = "Hello, \(textToAttach)"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureExploreButton() {
        exploreButton.clipsToBounds = true
        exploreButton.layer.cornerRadius = exploreButton.layer.frame.height / 2
        exploreButton.backgroundColor = UIColor.init(red: 64/255, green: 131/255, blue: 255/255, alpha: 1.0)
    }
    
    func configureAnimatedLabel() {
        self.animatedLabel.onlyDrawDirtyArea = true;
        self.animatedLabel.layerBased = false;
        
        self.animatedLabel.animationDuration = 1.0
        self.animatedLabel.animationDelay = 0.07
        
        self.animatedLabel.text = "Glad to see You."
        
        let mutatedString: NSAttributedString = NSAttributedString(string: self.animatedLabel.text, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 34.0, weight: UIFontWeightSemibold), NSForegroundColorAttributeName: UIColor.init(red: 78/255, green: 78/255, blue: 78/255, alpha: 1.0)])
        
        self.animatedLabel.attributedString = mutatedString
    }
    
    func configureAnimatedLabelS() {
        self.animatedLabelS.onlyDrawDirtyArea = true;
        self.animatedLabelS.layerBased = false;
        
        self.animatedLabelS.animationDuration = 1.0
        self.animatedLabelS.animationDelay = 0.07
        
        self.animatedLabelS.text = "Let's begin the journey!"
        
        let mutatedString: NSAttributedString = NSAttributedString(string: self.animatedLabelS.text, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 21.0, weight: UIFontWeightRegular), NSForegroundColorAttributeName: UIColor.init(red: 78/255, green: 78/255, blue: 78/255, alpha: 1.0)])
        
        self.animatedLabelS.attributedString = mutatedString
    }
    
    func animationFinished() {
        UIView.animate(withDuration: 1.0, animations: { 
            //self.exploreButton.alpha = 0.0
        }) { (success) in
            let tabBarVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarViewController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.changeRootViewCintroller(viewController: tabBarVC)
        }
    }
    
    @IBAction func exploreButtonnTapped(_ sender: UIButton) {
        sender.isEnabled = false
        
        self.configureAnimatedLabel()
        self.configureAnimatedLabelS()
        
        UIView.animate(withDuration: 1.0) { 
            self.helloLabel.alpha = 0.0
            self.welcomeLabel.alpha = 0.0
            self.exploreButton.alpha = 0.5
        }
        
        self.animatedLabel.startAppearAnimation()
        self.animatedLabelS.startAppearAnimation()
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
