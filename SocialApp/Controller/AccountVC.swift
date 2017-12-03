//
//  AccountVC.swift
//  SocialApp
//
//  Created by baytoor on 11/24/17.
//  Copyright © 2017 unicorn. All rights reserved.
//

import UIKit

class AccountVC: UIViewController {
    
    @IBOutlet weak var profilePhotoView: UIImageView!
    @IBOutlet weak var displayNameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var phoneNumberLbl: UILabel!
    @IBOutlet weak var infoLbl: UILabel!
    
    var isDriver: Int?
    var isVerified: Bool?
    
    override func viewDidAppear(_ animated: Bool) {
        getInfo()
        reloadUser()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getInfo(){
        if let data = NSData(contentsOf: URL(string: User.init().photoURL)!){
            profilePhotoView.image = UIImage(data: data as Data)
        }
        profilePhotoView.layer.cornerRadius = profilePhotoView.frame.width/2
        profilePhotoView.layer.masksToBounds = true
        displayNameLbl.text = User.init().displayName
        emailLbl.text = User.init().email
        phoneNumberLbl.text = User.init().phoneNumber
        if User.init().info.count > 1 {
            infoLbl.text = "\(User.init().info)"
        }
        isDriver = User.init().isDriver
        isVerified = User.init().isVerified
    }
    
    @IBAction func settingsBtnPressed(_ sender: Any){
        if isInternetAvailable() {
            performSegue(withIdentifier: "SettingsVC", sender: nil)
        } else {
            let alert = UIAlertController(title: "No internet connection", message: "Please, check internet connection and try again", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination: SettingsVC = segue.destination as! SettingsVC
        destination.photoData = UIImagePNGRepresentation(profilePhotoView.image!)
        if displayNameLbl.text != nil {
            destination.displayName = displayNameLbl.text
        } else {
            destination.displayName = "Name Surname"
        }
        if phoneNumberLbl.text != nil{
            destination.phoneNumber = phoneNumberLbl.text
        } else {
            destination.phoneNumber = ""
        }
        if infoLbl.text != nil {
            destination.info = infoLbl.text
        } else {
            destination.info = "Faculty Course"
        }
        if isVerified != nil {
           destination.isVerified = isVerified
        } else {
            destination.isVerified = false
        }
        if isDriver != nil {
           destination.isDriver = isDriver
        } else {
            destination.isDriver = 0
        }
        destination.email = emailLbl.text
    }
    

}
