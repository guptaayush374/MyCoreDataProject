//
//  CreateCompanyViewController.swift
//  MyCoreDataProject
//
//  Created by Netzealous on 08/04/19.
//  Copyright © 2019 Simpliv LLC. All rights reserved.
//

import UIKit

protocol DataEnteredDelegate: class {
    func userDidEnterInformation(company: Company)
}

class CreateCompanyViewController: UIViewController {
    
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var textFieldName: UITextField!
    
    weak var delegate: DataEnteredDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpNavigationItem()
    }
    
    func setUpNavigationItem() {
        navigationItem.title = "Create Company"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAddCompany))
    }
    
    @objc func handleAddCompany() {
        print("Adding Company...")
        
        if (self.delegate != nil) {
            guard let name = self.textFieldName.text else { return }
            let company = Company(name: name, founded: Date())
            delegate?.userDidEnterInformation(company: company)
            self.navigationController?.popViewController(animated: true)
        } else {
            print("Delegate is nil.")
        }
    }
}
