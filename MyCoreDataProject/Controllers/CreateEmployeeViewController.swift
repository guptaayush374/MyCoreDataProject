//
//  CreateEmployeeViewController.swift
//  MyCoreDataProject
//
//  Created by Shahanshah Manzoor on 17/04/19.
//  Copyright © 2019 Simpliv LLC. All rights reserved.
//

import UIKit

class CreateEmployeeViewController: UIViewController {
    
    
    @IBOutlet weak var lblEmployeeName: UILabel!
    @IBOutlet weak var txtFieldEmployeeName: UITextField!
    
    @IBOutlet weak var lblEmployeeBirthday: UILabel!
    @IBOutlet weak var txtFieldEmployeeBirthday: UITextField!
    
    @IBOutlet weak var lblProfile: UILabel!
    @IBOutlet weak var segmentProfile: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Create Employee"
        
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
        let error = CoreDataManager.shared.createEmployee(employeeName: employeeName)
        if let error = error {
            print(error)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func handleCancel() {
        self.navigationController?.popViewController(animated: true)
    }
}
