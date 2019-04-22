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
    
    var allEmployees = [[Employee]]()
    
    var employeeTypes = [
        EmployeeType.Executive.rawValue,
        EmployeeType.Manager.rawValue,
        EmployeeType.Staff.rawValue,
        EmployeeType.Intern.rawValue
    ]
    
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
        
        self.allEmployees = []
        
        guard let companyEmployees = self.company?.employees?.allObjects as? [Employee] else { return }
        
        employeeTypes.forEach { (employeeType) in
            allEmployees.append(
                companyEmployees.filter { $0.type == employeeType }
            )
        }
        
        
        //        let executives = companyEmployees.filter { (employees) -> Bool in
        //            return employees.type == EmployeeType.Executive.rawValue
        //        }
        //
        //        let manager = companyEmployees.filter { (employees) -> Bool in
        //            return employees.type == EmployeeType.Manager.rawValue
        //        }
        //
        //        let staff = companyEmployees.filter { $0.type == EmployeeType.Staff.rawValue }
        //
        //        self.allEmployees = [
        //            executives,
        //            manager,
        //            staff
        //        ]
    }
    
    @objc private func handleAdd() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateEmployeeViewController") as! CreateEmployeeViewController
        vc.delegate = self
        vc.company = self.company
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension EmployeesViewController: CreateEmployeeViewControllerDelegate {
    
    func didAddEmployee(employee: Employee) {
        //employees.append(employee)
        
//        self.fetchEmployees()
//        self.tableViewEmployee.reloadData()
        
        guard let section = employeeTypes.firstIndex(of: employee.type!) else { return }
        let row = allEmployees[section].count
        let insertionIndexPath = IndexPath(row: row, section: section)
        allEmployees[section].append(employee)
        tableViewEmployee.insertRows(at: [insertionIndexPath], with: .middle)
    }
}

extension EmployeesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.allEmployees.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allEmployees[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeesTVCell", for: indexPath) as! EmployeesTVCell
        
        let employee = self.allEmployees[indexPath.section][indexPath.row]
        
        cell.lblEmployeeName.text = employee.name
        
        if let birthday = employee.employeeInfo?.birthday {
            cell.lblEmployeeName.text = "\(employee.name ?? "") : \(birthday)"
        }
        
        cell.backgroundColor = UIColor.tealColor
        cell.lblEmployeeName.textColor = UIColor.white
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.employeeTypes[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        guard let header = view as? UITableViewHeaderFooterView else { return }
        
        header.textLabel?.textColor = .darkGray
        header.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 15.0)!
        header.backgroundView?.backgroundColor = .white
    }
    
}
