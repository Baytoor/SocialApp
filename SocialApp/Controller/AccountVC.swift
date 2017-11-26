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

    override func viewDidLoad() {
        super.viewDidLoad()
        getInfo()
        let user = User.init()
        DataService.ds.createUser(user)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getInfo()
    }
    
    func getInfo(){
        let user = User.init()
        if let data = NSData(contentsOf: URL(string: user.photoURL)!){
            profilePhotoView.image = UIImage(data: data as Data)
        }
        profilePhotoView.layer.cornerRadius = profilePhotoView.frame.width/2
        profilePhotoView.layer.masksToBounds = true
        displayNameLbl.text = user.displayName
        emailLbl.text = user.email
        phoneNumberLbl.text = user.phoneNumber
        infoLbl.text = user.info
    }
    
    @IBAction func settingsBtnPressed(_ sender: Any){
        performSegue(withIdentifier: "SettingsVC", sender: nil)
    }
    

}
