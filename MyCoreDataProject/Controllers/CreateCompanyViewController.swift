//
//  CreateCompanyViewController.swift
//  MyCoreDataProject
//
//  Created by Netzealous on 08/04/19.
//  Copyright © 2019 Simpliv LLC. All rights reserved.
//

import UIKit
import CoreData

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
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
        company.setValue(self.textFieldName.text, forKey: "name")
        
        do {
            try context.save()
            delegate?.userDidEnterInformation(company: company as! Company)
            if (self.delegate != nil) {
                self.navigationController?.popViewController(animated: true)
            } else {
                print("Delegate is nil.")
            }
        } catch let saveErr {
            print("Failed to save company: ", saveErr)
        }
    }
}
