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

    @IBOutlet weak var prosessingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var facebook: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var signInBtn: UIButton!
    
//    var isEditingMode = false
    
    override func viewWillAppear(_ animated: Bool) {
        prosessingIndicator.isHidden = true
        view.alpha = 1
        prosessingIndicator.isHidden = true
        signInBtn.isEnabled = true
        emailField.text = ""
        passField.text = ""
        errorLbl.text = ""
        self.signInBtn.isEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(darkBlue)
        facebook.setImage(#imageLiteral(resourceName: "facebook").maskWithColor(color: UIColor(lightBlue)), for: .highlighted)
        view.alpha = 1
        prosessingIndicator.isHidden = true
        signInBtn.isEnabled = true
        emailField.text = ""
        passField.text = ""
        errorLbl.text = ""
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.textFieldShouldReturn(_:)))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: keyUID) {
            performSegue(withIdentifier: "accessApp", sender: nil)
        }
    }
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
//    @IBAction func editingMode(_ sender: Any) {
//        if !isEditingMode {
//            UIView.animate(withDuration: 0.3, animations: {
//                self.errorLbl.center.y = self.errorLbl.center.y-178
//                self.stackView.center.y = self.stackView.center.y-178
//            })
//            logo.isHidden = true
//            isEditingMode = true
//        }
//    }
//
//    func finishEditing() {
//        self.view.endEditing(true)
//        if isEditingMode{
//            UIView.animate(withDuration: 0.3, animations: {
//                self.errorLbl.center.y = self.errorLbl.center.y+178
//                self.stackView.center.y = self.stackView.center.y+178
//            })
//            logo.isHidden = false
//            isEditingMode = false
//        }
//    }
    
    @IBAction func signInPressed(_ sender: Any) {
        signInBtn.isEnabled = false
        if let email = emailField.text, let pass = passField.text {
            if email=="" {
                self.errorLbl.isHidden = false
                self.errorLbl.text = "Field is empty"
                self.errorLbl.textColor = UIColor.red
                signInBtn.isEnabled = true
            }else if pass.count >= 6 {
            Auth.auth().signIn(withEmail: email, password: pass, completion: { (user, error) in
                if error == nil {
                    print("MSG: User authenticated with firebase using email")
                    if let user = user {
                        self.completeSignIn(id: user.uid)
                    }
                } else {
                    let errCode = AuthErrorCode(rawValue: error!._code)
                    if errCode == AuthErrorCode.userNotFound{
                        Auth.auth().createUser(withEmail: email, password: pass, completion: { (user, error) in
                            if error != nil {
                                print("MSG: Unable to authenticate with firebase using email")
                                self.signInBtn.isEnabled = true
                            } else {
                                print("MSG: New user was created using email")
                                if let user = user {
                                    self.completeSignIn(id: user.uid)
                                }
                            }
                        })
                    } else if errCode == AuthErrorCode.invalidEmail {
                        self.errorLbl.isHidden = false
                        self.errorLbl.text = "Invalid email"
                        self.errorLbl.textColor = UIColor.red
                        self.signInBtn.isEnabled = true
                    } else if errCode == AuthErrorCode.wrongPassword {
                        self.errorLbl.isHidden = false
                        self.errorLbl.text = "Wrong password"
                        self.errorLbl.textColor = UIColor.red
                        self.signInBtn.isEnabled = true
                    }
                }
            })
            } else {
                errorLbl.isHidden = false
                errorLbl.text = "Password must have 6 characters"
                errorLbl.textColor = UIColor.red
                signInBtn.isEnabled = true
            }
        }
    }
    
    @IBAction func fbRegisterBtn(_ sender: Any){
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("MSG: Unable to authenticate with facebook \(String(describing: error))")
            } else if result?.isCancelled == true {
                print("MSG: User cancelled facebook authentication")
            } else {
                print("MSG: Succesfully authenticated with facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }

    func firebaseAuth(_ credential: AuthCredential ) {
        signInBtn.isEnabled = false
        view.alpha = 0.5
        prosessingIndicator.isHidden = false
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print("MSG: Unable to authenticate with firebase \(String(describing: error))")
                self.signInBtn.isEnabled = true
                self.view.alpha = 1
                self.prosessingIndicator.isHidden = true
            } else {
                print("MSG: Succesfully authenticated with firebase")
                if let user = user {
                    self.completeSignIn(id: user.uid)
                }
            }
        }
    }
    
    func completeSignIn(id: String) {
        let saveSuccessful: Bool = KeychainWrapper.standard.set(id, forKey: keyUID)
        if saveSuccessful {
            print("MSG: Data saved to keychain")
        }
        performSegue(withIdentifier: "accessApp", sender: nil)
    }
    
    
}










