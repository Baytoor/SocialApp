//
//  ViewController.swift
//  SocialApp
//
//  Created by baytoor on 11/12/17.
//  Copyright © 2017 unicorn. All rights reserved.
//

import UIKit

class LaunchPageVC: UIViewController {

    @IBOutlet weak var facebook: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        facebook.imageView?.image? = (facebook.imageView?.image?.maskWithColor(color: UIColor.white))!
    }

    @IBAction func signInPage(_ sender: Any) {
        self.performSegue(withIdentifier: "SignInVC", sender: self)
    }
    
    @IBAction func registerPage(_ sender: Any) {
        self.performSegue(withIdentifier: "SignInVC", sender: self)
    }

    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "SignInVC" {
//            let destination = segue.destination as! SignInVC
//
//        }
//    }
}

