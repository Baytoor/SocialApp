//
//  SettingsVC.swift
//  SocialApp
//
//  Created by baytoor on 11/26/17.
//  Copyright © 2017 unicorn. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class SettingsVC: UIViewController {
    
    @IBOutlet weak var profilePhotoView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surNameField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var facultyField: UITextField!
    @IBOutlet weak var courseField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        getInfo()
        
    }
    
    func getInfo(){
        if let data = NSData(contentsOf: URL(string: signedInUser.photoURL)!){
            profilePhotoView.image = UIImage(data: data as Data)
        }
        profilePhotoView.layer.cornerRadius = profilePhotoView.frame.width/2
        profilePhotoView.layer.masksToBounds = true
        
        if signedInUser.displayName != ""{
            let displayName = signedInUser.displayName.components(separatedBy: " ")
            nameField.text = displayName[0]
            surNameField.text = displayName[1]
        } else {
            nameField.placeholder = "Name"
            surNameField.placeholder = "Surname"
        }
        if signedInUser.faculty != "" {
            facultyField.text = signedInUser.faculty
        } else {
            facultyField.placeholder = "Faculty"
        }
        if signedInUser.course != "" {
            courseField.text = signedInUser.course
        } else {
            courseField.placeholder = "Course"
        }
        if signedInUser.phoneNumber != "" {
            phoneNumberField.text = signedInUser.phoneNumber
        } else {
            phoneNumberField.placeholder = "+7 (___) ___ __ __"
        }
        
        
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
        if self.facultyField.text != "" && self.courseField.text != "" {
            let user = User.init(self.facultyField.text!, self.courseField.text!)
            signedInUser = user
        }
        
    }

    @IBAction func signOutBtnPressed(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: keyUID)
        try! Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
        print("MSG: Signed out")
    }
    
}
