//
//  CompanyTVCell.swift
//  MyCoreDataProject
//
//  Created by Netzealous on 08/04/19.
//  Copyright © 2019 Simpliv LLC. All rights reserved.
//

import UIKit

class CompanyTVCell: UITableViewCell {
    
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    
    var company: Company? {
        didSet {
            
            if let name = company?.name, let founded = company?.founded {
                let nameFounded = name + " (" + founded + ")"
                self.lblCompanyName.text = nameFounded
            } else {
                self.lblCompanyName.text = company?.name
            }
            
            self.imgProfile.image = #imageLiteral(resourceName: "default-profile-pic")
            if let imgData = company?.imageData {
                self.imgProfile?.image = UIImage(data: imgData)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = UIColor.tealColor
        
        self.lblCompanyName.textColor = .white
        self.lblCompanyName.font = UIFont.boldSystemFont(ofSize: 16)
        
        self.imgProfile.contentMode = .scaleAspectFill
        self.imgProfile.translatesAutoresizingMaskIntoConstraints = false
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.height/2
        self.imgProfile.clipsToBounds = true
    }
}
