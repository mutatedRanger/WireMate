//
//  SignUpViewController.swift
//  WireMate
//
//  Created by Hubert on 07.08.2017.
//  Copyright © 2017 Sidereum. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import GoogleSignIn

class SignUpViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate{

    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var gButton: UIButton!
    
    var sessionManager: SessionManager!
    var serverTrustPolicy: ServerTrustPolicy!
    var serverTrustPolicies: Dictionary<String, ServerTrustPolicy>!
    
    var activityIndicator: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - GIDSignInDelegate
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            //let userId = user.userID                  // For client-side use only!
            //let idToken = user.authentication.idToken // Safe to send to the server
            //let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            
            if let _givenName = givenName, let _familyName = familyName, let _email = email {
                let dataSet = ["email": _email, "firstName": _givenName, "lastName": _familyName]
                DispatchQueue.global(qos: .utility).async {
                    self.pushToExternalDB(argDic: dataSet)
                    DispatchQueue.main.async {
                        let welcomeVC = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeViewController
                        welcomeVC.nametoDisplay = _givenName
                        self.navigationController?.pushViewController(welcomeVC, animated: true)
                    }
                }
            }
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
    }
    
    // MARK: - GIDSignInUIDelegate
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        activityIndicator.stopAnimating()
        fbButton.isEnabled = true
        gButton.isEnabled = true
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func configureActivityView(_ sender: UIButton) {
        activityIndicator = NVActivityIndicatorView(frame: CGRect.init(x: 0.8 * sender.frame.width, y: sender.frame.height/2 - sender.bounds.height/4, width: sender.bounds.height/2, height: sender.bounds.height/2), type: .lineScale, color: UIColor.white, padding: 0)
        sender.addSubview(activityIndicator)
    }
    
    private func configureAlertView() -> UIAlertController{
        let controller = UIAlertController(title: "Sign Up Alert", message: "You have not granted all permissions. Do You want to proceed further offline or try again? ", preferredStyle: .actionSheet)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in
            self.fbButton.isEnabled = true
            self.gButton.isEnabled = true
        }
        
        let confirmationButton = UIAlertAction(title: "Go further", style: .default) { (alertAction) in
            let welcomeVC = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeViewController
            self.navigationController?.pushViewController(welcomeVC, animated: true)
        }
        
        controller.addAction(confirmationButton)
        controller.addAction(cancelButton)
        
        return controller
    }
    
    func configureAlamoFireSSLPinning() {
        let hostName: String = "wmat.cba.pl"
        let cert = "cert"
        
        let pathToCert = Bundle.main.path(forResource: cert, ofType: "der")
        let localCertificate:NSData = NSData(contentsOfFile: pathToCert!)!
        
        let certificates: [SecCertificate] = [SecCertificateCreateWithData(nil, localCertificate)!]
        
        self.serverTrustPolicy = ServerTrustPolicy.pinCertificates(certificates: certificates, validateCertificateChain: true, validateHost: true)
        
        self.serverTrustPolicies = [hostName: serverTrustPolicy!]
        
        self.sessionManager = SessionManager(serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
    }
    
    func pushToExternalDB(argDic: Dictionary<String, String>) {
        /*
         SSL pinning is temporarily inactive due to unaccessabilty of proper SSL certificate. In order to use it:
                1. Uncomment 'self.configureAlamoFireSSLPinning()'
                2. Change Alamofire to sessionManager
                3. Provide proper SSL certificate by attaching it to Xcode project. Certificate can be obtained by using following caommand: 'openssl x509 -in INPUT_CERT -out cert.der -outform DER'
         */
        //self.configureAlamoFireSSLPinning()
        print(Alamofire.request("http://www.wmat.cba.pl/api/createteam.php", method: .post, parameters: argDic, encoding: URLEncoding.default, headers: nil).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("Server response: \(json)")
            case .failure(let error):
                print(error)
            }
        }.debugDescription)
    }
    
    @IBAction func logInWithFB(_ sender: UIButton) {
        fbButton.isEnabled = false
        gButton.isEnabled = false
        
        configureActivityView(sender)
        activityIndicator.startAnimating()
        
        let logInManager = FBSDKLoginManager.init()
        
        logInManager.logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, error) in
            defer {
                self.activityIndicator.stopAnimating()
            }
            if (error != nil) {
                self.fbButton.isEnabled = true
                self.gButton.isEnabled = true
                return
            } else if (result?.isCancelled)! {
                logInManager.logOut()
                self.fbButton.isEnabled = true
                self.gButton.isEnabled = true
                return
            } else {
                if (result?.grantedPermissions.contains("email"))! && (result?.grantedPermissions.contains("public_profile"))! {
                    if FBSDKAccessToken.current() != nil {
                        let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email, first_name, last_name"])
                        
                        graphRequest.start(completionHandler: { (_connection, _result, _error) in
                            if _error !=  nil {
                                print("Error occured while gathering data.")
                            } else {
                                if let result = _result as? [String:Any] {
                                    guard let email = result["email"] as? String else {
                                        return
                                    }
                                    guard let firstName = result["first_name"] as? String else {
                                        return
                                    }
                                    guard let lastName = result["last_name"] as? String else{
                                        return
                                    }
                                    let userCredentials = ["email": email, "firstName": firstName, "lastName": lastName]
                                    DispatchQueue.global(qos: .utility).async {
                                        self.pushToExternalDB(argDic: userCredentials)
                                        DispatchQueue.main.async {
                                            let welcomeVC = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeViewController
                                            welcomeVC.nametoDisplay = firstName
                                            self.navigationController?.pushViewController(welcomeVC, animated: true)
                                        }
                                    }
                                }
                            }
                        })
                    }
                } else {
                    self.present(self.configureAlertView(), animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func logInWithG(_ sender: UIButton) {
        fbButton.isEnabled = false
        gButton.isEnabled = false
        
        configureActivityView(sender)
        activityIndicator.startAnimating()
        
        GIDSignIn.sharedInstance().signIn()
    }

    @IBAction func notReadyButtonClicked(_ sender: UIButton) {
        let welcomeVC = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeViewController
        self.navigationController?.pushViewController(welcomeVC, animated: true)
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
