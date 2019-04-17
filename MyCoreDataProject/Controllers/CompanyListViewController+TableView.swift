//
//  CompanyListViewController+TableView.swift
//  MyCoreDataProject
//
//  Created by Shahanshah Manzoor on 16/04/19.
//  Copyright © 2019 Simpliv LLC. All rights reserved.
//

import UIKit

extension CompanyListViewController: UITableViewDataSource, UITableViewDelegate {
    
    private func editHandlerFunction(action: UITableViewRowAction, indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateCompanyViewController") as! CreateCompanyViewController
        vc.company = self.companies[indexPath.row]
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.companies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyTVCell", for: indexPath) as! CompanyTVCell
        
        let company = self.companies[indexPath.row]
        cell.company = company
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EmployeesViewController") as! EmployeesViewController
        let company = companies[indexPath.row]
        vc.company = company
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
            let company = self.companies[indexPath.row]
            print("Attempting to delete company: ", company.name ?? "")
            
            // Remove the company from our tableview
            self.companies.remove(at: indexPath.row)
            self.tableViewCompanyList.deleteRows(at: [indexPath], with: .automatic)
            
            // Remove the company from core data
            let context = CoreDataManager.shared.persistentContainer.viewContext
            context.delete(company)
            
            do {
                try context.save()
            } catch let delErr {
                print("Failed to delete company: ", delErr)
            }
        }
        deleteAction.backgroundColor = UIColor.lightRed
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: editHandlerFunction)
        editAction.backgroundColor = UIColor.darkBlue
        
        return [deleteAction, editAction]
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "No Companies Available"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.companies.count == 0 ? 150 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.lightBlue
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
}
