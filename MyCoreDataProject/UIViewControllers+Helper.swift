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
    
    func showAlertWithAction(withTitle title: String, andMessage message: String, actionHandler: (()->())?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            if let handler = actionHandler {
                handler()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
