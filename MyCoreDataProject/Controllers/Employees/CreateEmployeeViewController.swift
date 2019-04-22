//
//  CreateEmployeeViewController.swift
//  MyCoreDataProject
//
//  Created by Shahanshah Manzoor on 17/04/19.
//  Copyright © 2019 Simpliv LLC. All rights reserved.
//

import UIKit

protocol CreateEmployeeViewControllerDelegate {
    func didAddEmployee(employee: Employee)
}

class CreateEmployeeViewController: UIViewController {
    
    @IBOutlet weak var lblEmployeeName: UILabel!
    @IBOutlet weak var txtFieldEmployeeName: UITextField!
    
    @IBOutlet weak var lblEmployeeBirthday: UILabel!
    @IBOutlet weak var txtFieldEmployeeBirthday: UITextField!
    
    @IBOutlet weak var lblProfile: UILabel!
    @IBOutlet weak var segmentProfile: UISegmentedControl!
    
    var delegate: CreateEmployeeViewControllerDelegate?
    
    var company: Company?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Create Employee"
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.setUpSaveButtonInNavBar(with: #selector(handleSave))
        self.setUpCancelButtonInNavBar(with: #selector(handleCancel))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        view.backgroundColor = UIColor.darkBlue
    }
    
    @IBAction func selectProfileFromSegmentOptions(_ sender: UISegmentedControl) {
        
    }
    
    @objc func handleSave() {
        
        guard let employeeName = self.txtFieldEmployeeName.text else { return }
        guard let birthday = self.txtFieldEmployeeBirthday.text else { return }

        guard let company = self.company else { return }
        
        if employeeName.isEmpty {
            self.showAlertWithAction(withTitle: "Alert!", andMessage: "Please enter your name.", actionHandler: nil)
        }
        
        if birthday.isEmpty {
            self.showAlertWithAction(withTitle: "Alert!", andMessage: "Please enter your birthday.", actionHandler: nil)
        }
        
        guard let employeeType = self.segmentProfile.titleForSegment(at: self.segmentProfile.selectedSegmentIndex) else { return }
        print(employeeType)
        
        let tuple = CoreDataManager.shared.createEmployee(employeeName: employeeName, birthday: birthday, employeeType: employeeType, company: company)
        if let error = tuple.1 {
            print(error)
        } else {
            self.navigationController?.popViewController(animated: true)
            self.delegate?.didAddEmployee(employee: tuple.0!)
        }
    }
    
    @objc func handleCancel() {
        self.navigationController?.popViewController(animated: true)
    }
}
