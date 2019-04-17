//
//  EmployeesViewController.swift
//  MyCoreDataProject
//
//  Created by Shahanshah Manzoor on 17/04/19.
//  Copyright © 2019 Simpliv LLC. All rights reserved.
//

import UIKit

class EmployeesViewController: UIViewController {

    @IBOutlet weak var tableViewEmployee: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableViewEmployee.dataSource = self
        self.tableViewEmployee.delegate = self
        
        self.tableViewEmployee.reloadData()
    }
}

extension EmployeesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeesTVCell", for: indexPath) as! EmployeesTVCell
        cell.lblEmployeeName.text = "Ram Ram"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}
