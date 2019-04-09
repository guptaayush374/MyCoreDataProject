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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = UIColor.tealColor
        self.lblCompanyName.textColor = .white
        self.lblCompanyName.font = UIFont.boldSystemFont(ofSize: 16)
    }
}
