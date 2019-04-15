//
//  CreateCompanyViewController.swift
//  MyCoreDataProject
//
//  Created by Netzealous on 08/04/19.
//  Copyright © 2019 Simpliv LLC. All rights reserved.
//

import UIKit
import CoreData

protocol CreateCompanyViewControllerDelegate: class {
    func disAddCompany(company: Company)
    func didEditCompany(company: Company)
}

class CreateCompanyViewController: UIViewController {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var lblFounded: UILabel!
    @IBOutlet weak var textFieldFounded: UITextField!
    
    var company: Company?
    
    weak var delegate: CreateCompanyViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpNavigationItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = self.company == nil ? "Create Company" : "Edit Company"
        self.textFieldName.text = self.company?.name == nil ? "" : self.company?.name
        self.textFieldFounded.text = self.company?.founded == nil ? "" : self.company?.founded

    }
    
    func setUpNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }
    
    @objc func handleSave() {
        
        if self.company == nil {
            self.createCompany()
        } else {
            self.updateCompany()
        }
    }
    
    private func createCompany() {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
        company.setValue(self.textFieldName.text, forKey: "name")
        company.setValue(self.textFieldFounded.text, forKey: "founded")
        
        do {
            try context.save()
            delegate?.disAddCompany(company: company as! Company)
            if (self.delegate != nil) {
                self.navigationController?.popViewController(animated: true)
            } else {
                print("Delegate is nil.")
            }
        } catch let saveErr {
            print("Failed to save company: ", saveErr)
        }
    }
    
    private func updateCompany() {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        self.company?.name = self.textFieldName.text
        self.company?.founded = self.textFieldFounded.text

        do {
            try context.save()
            delegate?.didEditCompany(company: self.company!)
            if (self.delegate != nil) {
                self.navigationController?.popViewController(animated: true)
            } else {
                print("Delegate is nil.")
            }
        } catch let err {
            print("Failed to save company: ", err)
        }
    }
}
