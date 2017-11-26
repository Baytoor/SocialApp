//
//  ViewController.swift
//  SocialApp
//
//  Created by baytoor on 11/12/17.
//  Copyright © 2017 unicorn. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import FirebaseAuth
import SwiftKeychainWrapper

class LaunchPageVC: UIViewController {

    @IBOutlet weak var processingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var facebook: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var signInBtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        outProcess()
        emailField.text = ""
        passField.text = ""
        errorLbl.text = ""
        self.signInBtn.isEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(darkBlue)
        facebook.setImage(#imageLiteral(resourceName: "facebook").maskWithColor(color: UIColor(lightBlue)), for: .highlighted)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.textFieldShouldReturn(_:)))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: keyUID) {
            performSegue(withIdentifier: "accessApp", sender: nil)
            inProcess()
        }
    }
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    func inProcess() {
        signInBtn.isEnabled = false
        signInBtn.setTitle("", for: .normal)
        facebook.isEnabled = false
        facebook.alpha = 0.5
        logo.alpha = 0.5
        stackView.alpha = 0.5
        processingIndicator.isHidden = false
        processingIndicator.startAnimating()
    }
    
    func outProcess(){
        signInBtn.isEnabled = true
        signInBtn.setTitle("Sign In", for: .normal)
        facebook.isEnabled = true
        facebook.alpha = 1
        logo.alpha = 1
        stackView.alpha = 1
        processingIndicator.isHidden = true
        processingIndicator.stopAnimating()
    }
    
    func errorDescription(_ error: String){
        outProcess()
        errorLbl.isHidden = false
        errorLbl.text = error
        errorLbl.textColor = UIColor.red
        signInBtn.isEnabled = true
    }
    
    
    
    
}

extension LaunchPageVC {
    @IBAction func signInPressed(_ sender: Any) {
        inProcess()
        self.view.endEditing(true)
        if let email = emailField.text, let pass = passField.text {
            if email=="" || pass=="" {
                errorDescription("Field is empty")
            } else if pass.count < 6 {
                errorDescription("Password must have at least 6 characters")
            } else {
                Auth.auth().signIn(withEmail: email, password: pass, completion: { (user, error) in
                    if error == nil {
                        print("MSG: User authenticated with firebase using email")
                        if let user = user {
                            self.completeSignIn(uid: user.uid)
                        }
                    } else {
                        let errCode = AuthErrorCode(rawValue: error!._code)
                        if errCode == AuthErrorCode.userNotFound{
                            Auth.auth().createUser(withEmail: email, password: pass, completion: { (user, error) in
                                if error != nil {
                                    print("MSG: Unable to authenticate with firebase using email")
                                    self.errorDescription("Unable to authenticate with firebase")
                                    self.signInBtn.isEnabled = true
                                } else {
                                    print("MSG: New user was created using email")
                                    if let user = user {
                                        self.completeSignIn(uid: user.uid)
                                    }
                                }
                            })
                        } else if errCode == AuthErrorCode.invalidEmail {
                            self.errorDescription("Invalid email")
                        } else if errCode == AuthErrorCode.wrongPassword {
                            self.errorDescription("Wrong password")
                        }
                    }
                })
            }
        }
    }
    
    @IBAction func fbRegisterBtn(_ sender: Any){
        inProcess()
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("MSG: Unable to authenticate with facebook \(String(describing: error))")
                self.errorDescription("Unable to authenticate with facebook")
            } else if result?.isCancelled == true {
                print("MSG: User cancelled facebook authentication")
                self.outProcess()
            } else {
                print("MSG: Succesfully authenticated with facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: AuthCredential ) {
        inProcess()
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print("MSG: Unable to authenticate with firebase \(String(describing: error))")
                self.errorDescription("Unable to authenticate")
            } else {
                print("MSG: Succesfully authenticated with firebase")
                if let user = user {
                    self.completeSignIn(uid: user.uid)
                }
            }
        }
    }
    
    func completeSignIn(uid: String) {
        let passanger = Passanger.init("IS", "2", ["SportCar", "Starups", "iOS"])
        let userData = ["name": passanger.displayName, "email": passanger.email]
        DataService.ds.createFBDBUser(uid: uid, userData: userData)
        
        let saveSuccessful: Bool = KeychainWrapper.standard.set(uid, forKey: keyUID)
        if saveSuccessful {
            print("MSG: Data saved to keychain")
        }
        performSegue(withIdentifier: "accessApp", sender: nil)
    }
    
}










