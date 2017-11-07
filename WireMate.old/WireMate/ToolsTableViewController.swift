//
//  ToolsTableViewController.swift
//  WireMate
//
//  Created by Hubert on 14.08.2017.
//  Copyright © 2017 Sidereum. All rights reserved.
//

import UIKit

class ToolsTableViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var extendedView: ExtendedNavBarView!
    @IBOutlet weak var customSearchBar: CustomSearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // For the extended navigation bar effect to work, a few changes
        // must be made to the actual navigation bar.  Some of these changes could
        // be applied in the storyboard but are made in code for clarity.
        
        // Translucency of the navigation bar is disabled so that it matches with
        // the non-translucent background of the extension view.
        navigationController!.navigationBar.isTranslucent = false
        
        // The navigation bar's shadowImage is set to a transparent image.  In
        // addition to providing a custom background image, this removes
        // the grey hairline at the bottom of the navigation bar.  The
        // ExtendedNavBarView will draw its own hairline.
        navigationController!.navigationBar.shadowImage = #imageLiteral(resourceName: "TransparentPixel")
        // "Pixel" is a solid white 1x1 image.
        navigationController!.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "Pixel"), for: .default)
        
        self.configureNavigationBar()
        self.configureSeachBar()
        
        self.customSearchBar.delegate = self
        
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tapRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureNavigationBar() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.init(red: 64/255, green: 131/255, blue: 255/255, alpha: 1.0), NSFontAttributeName: UIFont.systemFont(ofSize: 18.0, weight: UIFontWeightMedium)]
    }
    
    func configureSeachBar() {
        let shadowView: UIView = UIView()
        let coordinateRect: CGRect = CGRect(x: (self.extendedView.frame.width - self.customSearchBar.frame.width) / 2, y: (self.extendedView.frame.height - 24) - (self.customSearchBar.frame.height - 10), width: self.customSearchBar.frame.width, height: self.customSearchBar.frame.height - 10.0)
        shadowView.clipsToBounds = false
        shadowView.layer.shadowColor = UIColor.init(white: 0.0, alpha: 0.25).cgColor
        shadowView.layer.shadowRadius = 2.0
        shadowView.layer.shadowOpacity = 1.0
        shadowView.layer.shadowPath = UIBezierPath(roundedRect: coordinateRect, cornerRadius: 6.0).cgPath
        shadowView.layer.shouldRasterize = true
        shadowView.layer.rasterizationScale = UIScreen.main.scale

        self.extendedView.insertSubview(shadowView, belowSubview: customSearchBar)
        
        let searchTextField: UITextField = customSearchBar.subviews[0].subviews.last as! UITextField
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 13.0, weight: UIFontWeightMedium), NSForegroundColorAttributeName: UIColor.init(red: 205/255, green: 205/255, blue: 205/255, alpha: 1.0)]
        searchTextField.leftView = UIImageView.init(image: UIImage(named: "Search"))
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search by Element, Connection or Cable", attributes: attributes)
        searchTextField.font = UIFont.systemFont(ofSize: 13.0, weight: UIFontWeightMedium)
        searchTextField.textColor = UIColor.init(red: 205/255, green: 205/255, blue: 205/255, alpha: 1.0)
    }
    
    func dismissKeyboard() {
        self.customSearchBar.resignFirstResponder()
    }
    
    //MARK: UISearchBarDelegate

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
