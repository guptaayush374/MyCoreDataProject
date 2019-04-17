//
//  EmployeesViewController.swift
//  MyCoreDataProject
//
//  Created by Shahanshah Manzoor on 17/04/19.
//  Copyright © 2019 Simpliv LLC. All rights reserved.
//

import UIKit
import CoreData

class EmployeesViewController: UIViewController {
    
    @IBOutlet weak var tableViewEmployee: UITableView!
    
    var company: Company?
    
    var employees = [Employee]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpPlusButtonInNavBar(with: #selector(handleAdd))
        
        self.tableViewEmployee.dataSource = self
        self.tableViewEmployee.delegate = self
        
        self.tableViewEmployee.reloadData()
        
        self.fetchEmployees()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationItem.title = self.company?.name
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tableViewEmployee.backgroundColor = UIColor.darkBlue
    }
    
    private func fetchEmployees() {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let request = NSFetchRequest<Employee>(entityName: "Employee")
        
        do {
            let employee = try context.fetch(request)
            self.employees = employee
            //employee.forEach { print("Employee name: ", $0.name ?? "") }
        } catch let err {
            print("Failed to fetch employee: ", err)
        }
    }
    
    @objc private func handleAdd() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateEmployeeViewController") as! CreateEmployeeViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension EmployeesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeesTVCell", for: indexPath) as! EmployeesTVCell
        cell.lblEmployeeName.text = self.employees[indexPath.row].name
        cell.backgroundColor = UIColor.tealColor
        cell.lblEmployeeName.textColor = UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}
