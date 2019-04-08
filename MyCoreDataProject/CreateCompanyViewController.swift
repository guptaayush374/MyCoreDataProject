//
//  CreateCompanyViewController.swift
//  MyCoreDataProject
//
//  Created by Netzealous on 08/04/19.
//  Copyright © 2019 Simpliv LLC. All rights reserved.
//

import UIKit

class CreateCompanyViewController: UIViewController {

    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var textFieldName: UITextField!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Create Company"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAddCompany))
    }
    
    @objc func handleAddCompany() {
        print("Adding Company...")
        
        guard let name = self.textFieldName.text else { return }
        let company = Company(name: name, founded: Date())
        
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "CompanyListViewController") as! CompanyListViewController
        secondViewController.addCompany(with: company)
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
}
