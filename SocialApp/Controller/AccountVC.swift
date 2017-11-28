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
    @IBOutlet weak var infoLbl: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        getInfo()
        Auth.auth().currentUser?.reload()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getInfo(){
        if User.init().photoURL != ""{
            if let data = NSData(contentsOf: URL(string: User.init().photoURL)!){
                profilePhotoView.image = UIImage(data: data as Data)
            }
        } else {
            profilePhotoView.image = #imageLiteral(resourceName: "noPhoto")
        }
        profilePhotoView.layer.cornerRadius = profilePhotoView.frame.width/2
        profilePhotoView.layer.masksToBounds = true
        displayNameLbl.text = User.init().displayName
        emailLbl.text = User.init().email
        phoneNumberLbl.text = User.init().phoneNumber
        infoLbl.text = "\(User.init().info) course"
    }
    
    @IBAction func settingsBtnPressed(_ sender: Any){
        performSegue(withIdentifier: "SettingsVC", sender: nil)
    }
    

}
