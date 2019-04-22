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
        
        self.companies = CoreDataManager.shared.fetchCompanies()
        self.tableViewCompanyList.reloadData()
        
        view.backgroundColor = UIColor.darkBlue
        navigationItem.title = "Companies"
        
        self.setUpPlusButtonInNavBar(with: #selector(handleAddCompany))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
        
        self.tableViewCompanyList.dataSource = self
        self.tableViewCompanyList.delegate = self
        
        self.tableViewCompanyList.separatorColor = .white
        self.tableViewCompanyList.backgroundColor = UIColor.darkBlue
    }
    
    @objc private func handleAddCompany() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateCompanyViewController") as! CreateCompanyViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func handleReset() {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        do {
            try context.execute(batchDeleteRequest)
            
            // Upon deletion from core data succeeded
            var indexPathsToRemove = [IndexPath]()
            for (index, _) in self.companies.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                indexPathsToRemove.append(indexPath)
            }
            self.companies.removeAll()
            self.tableViewCompanyList.deleteRows(at: indexPathsToRemove, with: .left)
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
}
