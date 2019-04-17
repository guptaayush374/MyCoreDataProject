//
//  UIViewControllers+Helper.swift
//  MyCoreDataProject
//
//  Created by Shahanshah Manzoor on 17/04/19.
//  Copyright © 2019 Simpliv LLC. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setUpPlusButtonInNavBar(with selector: Selector) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: selector)
    }
    
    func setUpCancelButtonInNavBar(with selector: Selector) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: selector)
    }
    
    func setUpSaveButtonInNavBar(with selector: Selector) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: selector)
    }
}
