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
    
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var profilePhotoView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surNameField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var facultyField: UITextField!
    @IBOutlet weak var courseField: UITextField!
    @IBOutlet weak var isDriverSC: UISegmentedControl!

    var imageUpdated = false
    var imagePicker: UIImagePickerController!
    var isSuccess = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getInfo()
        
        errorLbl.isHidden = true
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        bgView.layer.cornerRadius = bgView.frame.width/2
        bgView.layer.opacity = 0.7
        
        profilePhotoView.layer.cornerRadius = profilePhotoView.frame.width/2
        profilePhotoView.layer.masksToBounds = true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageUpdated = true
            profilePhotoView.image = resizeImage(image: image, targetSize: CGSize(width: 100, height: 100))
        } else {
            print("MSG: A valid image wasn't selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImageBtnPressed(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func updateDisplayName() {
        let authUser = Auth.auth().currentUser
        let changeRequest = authUser?.createProfileChangeRequest()
        if let name = self.nameField.text, let surname = self.surNameField.text {
            let newName = "\(name) \(surname)"
            if newName != "" && newName != User.init().displayName {
                changeRequest?.displayName = newName
                changeRequest?.commitChanges { error in
                    if error == nil {
                    } else {
                        self.errorDescription("Now it's not available to update profile name")
                    }
                }
            }
        }
    }
    
    func updateImage() {
        let authUser = Auth.auth().currentUser
        let changeRequest = authUser?.createProfileChangeRequest()
        if let data = NSData(contentsOf: URL(string: User.init().photoURL)!){
            let image = UIImage(data: data as Data)
            if image != profilePhotoView.image {
                isSuccess = false
                StorageServices.ss.uploadMedia(uid: User.init().uid, image: profilePhotoView.image!, completion:{ (url) in
                    changeRequest?.photoURL = url
                    changeRequest?.commitChanges { error in
                        if error == nil {
                            self.updateDisplayName()
                        } else {
                            self.errorDescription("Now it's not available to update profile image")
                        }
                    }
                })
            }
        } else {
            self.updateDisplayName()
        }
    }
    
    func updateInfo() {
        
        if self.phoneNumberField.text?.count==11  {
            let index = phoneNumberField.text!.index(phoneNumberField.text!.startIndex, offsetBy: 2)
            if String(self.phoneNumberField.text![..<index]) == "87" {
                defaults.set(self.phoneNumberField.text, forKey: "phoneNumber")
            }
        }
        if self.isDriverSC.selectedSegmentIndex != User.init().isDriver {
            defaults.set(isDriverSC.selectedSegmentIndex, forKey: "isDriver")
        }
        if self.facultyField.text != "" && self.courseField.text != User.init().faculty{
            defaults.set(self.facultyField.text, forKey: "faculty")
        }
        if self.courseField.text != "" && self.courseField.text != User.init().course {
            defaults.set(self.courseField.text, forKey: "course")
        }
        let user = User.init()
        DataService.ds.createUser(user)
    }
    
    func errorDescription(_ error: String){
        errorLbl.isHidden = false
        errorLbl.text = error
        errorLbl.textColor = UIColor.red
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        view.endEditing(true)
        inProcess()
        loadShows {
            self.outProcess()
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func loadShows(completionHandler: (() -> Void)!) {
        updateInfo()
        completionHandler()
    }
    
    func inProcess() {
        let uiBusy = UIActivityIndicatorView(activityIndicatorStyle: .white)
        uiBusy.hidesWhenStopped = true
        uiBusy.startAnimating()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: uiBusy)
        view.layer.opacity = 0.5
        view.isExclusiveTouch = false
    }
    
    func outProcess() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil, style: .done, target: nil, action: nil)
        view.layer.opacity = 1
    }

    @IBAction func signOutBtnPressed(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: keyUID)
        try! Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
        defaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        print("MSG: Signed out")
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func getInfo(){
        let user = User.init()
        if let data = NSData(contentsOf: URL(string: user.photoURL)!){
            profilePhotoView.image = UIImage(data: data as Data)
        }
        profilePhotoView.layer.cornerRadius = profilePhotoView.frame.width/2
        profilePhotoView.layer.masksToBounds = true
        
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
    
}
