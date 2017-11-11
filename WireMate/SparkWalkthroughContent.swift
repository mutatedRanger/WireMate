//
//  SparkWalkthroughContent.swift
//  WireMate
//
//  Created by Hubert  on 11.11.2017.
//  Copyright © 2017 Hubert Zajączkowski. All rights reserved.
//

import UIKit

class SparkWalkthroughContent: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    var pageIndex: Int = 0
    
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
}
