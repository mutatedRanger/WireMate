//
//  SparkWalkthroughContent.swift
//  WireMate
//
//  Created by Hubert on 07.08.2017.
//  Copyright © 2017 Sidereum. All rights reserved.
//

import UIKit

class SparkWalkthroughContent: UIViewController {
    
    var pageIndex: Int = 0
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    var titleText: String!
    var detailText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = titleText
        self.detailLabel.text = detailText
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
