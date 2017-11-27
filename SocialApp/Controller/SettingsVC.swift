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

class SettingsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var photoBg: UIView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var profilePhotoView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surNameField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var facultyField: UITextField!
    @IBOutlet weak var courseField: UITextField!
    @IBOutlet weak var isDriverSC: UISegmentedControl!
    
    var imageUpdated = false
    var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        getInfo()
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        profilePhotoView.layer.cornerRadius = profilePhotoView.frame.width/2
        profilePhotoView.layer.masksToBounds = true
        
        photoBg.backgroundColor = UIColor(darkBlue)
        photoBg.layer.opacity = 0.8
        photoBg.layer.cornerRadius = photoBg.frame.width/2
    }
    
    func getInfo(){
        let user = User.init()
        if let data = NSData(contentsOf: URL(string: user.photoURL)!){
            profilePhotoView.image = UIImage(data: data as Data)
        }
        if user.displayName != ""{
            let displayName = user.displayName.components(separatedBy: " ")
            nameField.text = displayName[0]
            surNameField.text = displayName[1]
        } else {
            nameField.placeholder = "Name"
            surNameField.placeholder = "Surname"
        }
        if user.faculty != "" {
            facultyField.text = user.faculty
        } else {
            facultyField.placeholder = "Faculty"
        }
        if user.course != "" {
            courseField.text = user.course
        } else {
            courseField.placeholder = "Course"
        }
        if user.phoneNumber != "" {
            phoneNumberField.text = user.phoneNumber
        } else {
            phoneNumberField.placeholder = "87*******"
        }
        isDriverSC.selectedSegmentIndex = user.isDriver
    }
    
    func updateInfo() {
        defaults.set(isDriverSC.selectedSegmentIndex, forKey: "isDriver")
        if self.phoneNumberField.text?.count==11  {
            let index = phoneNumberField.text!.index(phoneNumberField.text!.startIndex, offsetBy: 2)
            if String(self.phoneNumberField.text![..<index]) == "87" {
                defaults.set(self.phoneNumberField.text, forKey: "phoneNumber")
            }
        }
        if self.facultyField.text != "" {
            defaults.set(self.facultyField.text, forKey: "faculty")
        }
        if self.courseField.text != "" {
            defaults.set(self.courseField.text, forKey: "course")
        }
        if let name = self.nameField.text, let surname = self.surNameField.text {
            if name != "" && surname != "" {
                defaults.set("\(name) \(surname)", forKey: "displayName")
            }
        }
        if imageUpdated {
            
        }
        
        let user = User.init()
        DataService.ds.createUser(user)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageUpdated = true
            profilePhotoView.image = image
        } else {
            print("MSG: A valid image wasn't selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImageBtnPressed(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        updateInfo()
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func signOutBtnPressed(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: keyUID)
        try! Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
        defaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        print("MSG: Signed out")
    }
    
}
