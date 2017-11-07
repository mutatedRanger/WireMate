//
//  CustomSearchBar.swift
//  WireMate
//
//  Created by Hubert on 15.08.2017.
//  Copyright © 2017 Sidereum. All rights reserved.
//

import UIKit

class CustomSearchBar: UISearchBar {

    func indexOfSearchFieldInSubviews() -> Int! {
        var index: Int!
        let searchBarView = subviews[0] 
        
        for i in 0 ..< searchBarView.subviews.count {
            if searchBarView.subviews[i].isKind(of: UITextField.self) {
                index = i
                break
            }
        }
        
        return index
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        if let index = indexOfSearchFieldInSubviews() {
            let searchField: UITextField = subviews[0].subviews[index] as! UITextField
            
            searchField.frame = CGRect(x: 1.0, y: 1.0, width: frame.size.width - 2.0, height: frame.size.height - 2.0)
        }
        
        self.layer.cornerRadius = 6.0
        self.clipsToBounds = true
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.init(red: 208/255, green: 208/255, blue: 208/255, alpha: 1.0).cgColor
        
        super.draw(rect)
    }
}
