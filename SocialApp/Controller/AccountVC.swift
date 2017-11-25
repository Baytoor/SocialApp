//
//  AccountVC.swift
//  SocialApp
//
//  Created by baytoor on 11/24/17.
//  Copyright © 2017 unicorn. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class AccountVC: UIViewController {
    
    @IBOutlet weak var profilePhotoView: UIImageView!
    @IBOutlet weak var displayNameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var phoneNumberLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        getInfo()
        profilePhotoView.layer.cornerRadius = profilePhotoView.frame.width/2
        navigationItem.leftBarButtonItem?.action = #selector(self.signOutBtnPressed(_:))
    }
    
    func getInfo(){
        if let user = Auth.auth().currentUser{
            if let displayName = user.displayName{
                displayNameLbl.text = displayName
            } else {
                displayNameLbl.text = "No name"
            }
            if let email = user.email{
                emailLbl.text = email
            }
            if let phoneNumber = user.phoneNumber {
                phoneNumberLbl.text = phoneNumber
            } else {
                phoneNumberLbl.text = "No phone number"
            }
            if let photoURL = user.photoURL {
                if let data = NSData(contentsOf: photoURL) {
                    profilePhotoView.image = UIImage(data: data as Data)
                } else {
                    profilePhotoView.image = #imageLiteral(resourceName: "people").maskWithColor(color: UIColor(darkBlue))
                }
            } else {
                profilePhotoView.image = #imageLiteral(resourceName: "people").maskWithColor(color: UIColor(darkBlue))
            }
        }
    }
    

    @IBAction func signOutBtnPressed(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: keyUID)
        try! Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
        print("MSG: Signed out")
    }

}
