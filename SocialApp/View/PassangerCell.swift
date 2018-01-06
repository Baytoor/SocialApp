//
//  PassengerCell.swift
//  SocialApp
//
//  Created by baytoor on 11/26/17.
//  Copyright © 2017 unicorn. All rights reserved.
//

import UIKit

class PassangerCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var personImage: UIImageView!
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var personTime: UILabel!
    @IBOutlet weak var personDestination: UILabel!
    @IBOutlet weak var personInfo: UILabel!
    
    var person: OtherUser?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        personImage.layer.cornerRadius = personImage.frame.width/2
        personImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(otherUser: OtherUser) {
        personInfo.text = otherUser.info
        personName.text = otherUser.displayName
        personTime.text = otherUser.time
        personDestination.text = otherUser.destination
        personImage.imageFromUrl(urlString: otherUser.photoURL) {
            self.person = OtherUser(uid: otherUser.uid,displayName: self.personName.text!, photo: self.personImage.image!, phoneNumber: otherUser.phoneNumber, info: self.personInfo.text!, time: self.personTime.text!, destination: self.personDestination.text!, hasSeat: otherUser.hasSeat)
        }
        
       
    }

}
