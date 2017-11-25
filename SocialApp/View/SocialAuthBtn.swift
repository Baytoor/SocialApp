//
//  SocialAuth.swift
//  SocialApp
//
//  Created by baytoor on 11/25/17.
//  Copyright © 2017 unicorn. All rights reserved.
//

import UIKit

class SocialAuthBtn: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
//        layer.cornerRadius = self.frame.width/2
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        layer.borderColor = UIColor.white.cgColor
//        layer.borderWidth = 2
        self.imageView?.contentMode = .scaleAspectFit
    }

}
