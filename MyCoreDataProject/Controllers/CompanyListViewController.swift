//
//  ViewController.swift
//  MyCoreDataProject
//
//  Created by Netzealous on 08/04/19.
//  Copyright © 2019 Simpliv LLC. All rights reserved.
//

import UIKit
import CoreData

class CompanyListViewController: UIViewController {
    
    @IBOutlet weak var tableViewCompanyList: UITableView!
    
    var companies = [Company]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchRequest()
        
        view.backgroundColor = UIColor.darkBlue
        navigationItem.title = "Companies"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: #selector(handleAddCompany))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
        
        self.tableViewCompanyList.dataSource = self
        self.tableViewCompanyList.delegate = self
        
        self.tableViewCompanyList.separatorColor = .white
        self.tableViewCompanyList.backgroundColor = UIColor.darkBlue
    }
    
    func fetchRequest() {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        
        do {
            let companies = try context.fetch(fetchRequest)
            companies.forEach { (company) in
                print(company.name ?? "")
            }
            self.companies = companies
            self.tableViewCompanyList.reloadData()
        } catch let fetchErr {
            print("Failed to fetch companies: ", fetchErr)
        }
    }
    
    @objc private func handleAddCompany() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateCompanyViewController") as! CreateCompanyViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func handleReset() {
        print("Reset...")
        let context = CoreDataManager.shared.persistentContainer.viewContext
        self.companies.forEach { (company) in
            context.delete(company)
        }
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        
        do {
            try context.execute(batchDeleteRequest)
            self.companies.removeAll()
            self.tableViewCompanyList.reloadData()
        } catch let err {
            print("Failed to delete objects from coredata: ", err)
        }
    }
    
    func addCompany(with company: Company) {
        self.companies.append(company)
        print(self.companies)
        
        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        self.tableViewCompanyList.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    private func editHandlerFunction(action: UITableViewRowAction, indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateCompanyViewController") as! CreateCompanyViewController
        vc.company = self.companies[indexPath.row]
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension CompanyListViewController: CreateCompanyViewControllerDelegate {
    
    func disAddCompany(company: Company) {
        self.addCompany(with: company)
    }
    
    func didEditCompany(company: Company) {
        guard let row = self.companies.firstIndex(of: company) else { return }
        let reloadIndexPath = IndexPath(row: row, section: 0)
        self.tableViewCompanyList.reloadRows(at: [reloadIndexPath], with: .automatic)
    }
}

extension CompanyListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.companies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyTVCell", for: indexPath) as! CompanyTVCell
        
        let company = self.companies[indexPath.row]
        if company.founded != "" {
            cell.lblCompanyName.text = company.name! + " (" + company.founded! + ")"
        } else {
            cell.lblCompanyName.text = company.name!
        }
        
        cell.imgProfile.image = #imageLiteral(resourceName: "select_photo_empty")
        
        if let imgData = company.imageData {
            cell.imageView?.image = UIImage(data: imgData)
        }
        
        cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.height/2
        cell.imgProfile.clipsToBounds = true
        
        return cell
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
