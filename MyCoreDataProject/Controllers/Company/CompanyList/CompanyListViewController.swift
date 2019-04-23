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
    
    @IBOutlet weak var tableViewCompanyList: UITableView! {
        didSet {
            tableViewCompanyList.register(UINib(nibName: "CompanyTVCell", bundle: nil), forCellReuseIdentifier: "CompanyTVCell")
        }
    }
    
    var companies = [Company]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.companies = CoreDataManager.shared.fetchCompanies()
        self.tableViewCompanyList.reloadData()
        
        view.backgroundColor = UIColor.darkBlue
        navigationItem.title = "Companies"
        
        self.setUpPlusButtonInNavBar(with: #selector(handleAddCompany))
        
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset)),
            UIBarButtonItem(title: "Nested Update", style: .plain, target: self, action: #selector(doNestedUpdate))
        ]
        
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
    
    @objc private func handleDoWork() {
        
        CoreDataManager.shared.persistentContainer.performBackgroundTask({ (backgroundContext) in
            
            (0...5).forEach { (value) in
                let company = Company(context: backgroundContext)
                company.name = String(value)
            }
            
            do {
                try backgroundContext.save()
                
                DispatchQueue.main.async {
                    self.companies = CoreDataManager.shared.fetchCompanies()
                    self.tableViewCompanyList.reloadData()
                }
            } catch let err {
                print("Failed to save: ", err)
            }
        })
        
        // GCD - Grand Central Dispatch
        
        //        DispatchQueue.global(qos: .background).async {
        //        let context = CoreDataManager.shared.persistentContainer.viewContext
    }
    
    // let's do some tricky updates with core data
    @objc private func handleDoUpdate() {
        print("Trying to update companies on a background context")
        
        CoreDataManager.shared.persistentContainer.performBackgroundTask { (backgroundContext) in
            let request: NSFetchRequest<Company> = Company.fetchRequest()
            do {
                let companies = try backgroundContext.fetch(request)
                companies.forEach({ (company) in
                    print(company.name ?? "")
                    company.name = "C: \(company.name ?? "")"
                })
                do {
                    try backgroundContext.save()
                    
                    // let's try to update the UI after a save
                    DispatchQueue.main.async {
                        
                        // reset will forget all of the objects you've fetch before
                        CoreDataManager.shared.persistentContainer.viewContext.reset()
                        
                        // you don't want to refetch everything if you're just simply update one or two companies
                        
                        self.companies = CoreDataManager.shared.fetchCompanies()
                        
                        // is there a way to just merge the changes that you made onto the main view context?
                        
                        self.tableViewCompanyList.reloadData()
                    }
                } catch let saveErr {
                    print("Failed to save on background:", saveErr)
                }
            } catch let err {
                print("Failed to fetch companies on background:", err)
            }
        }
    }
    
    @objc private func doNestedUpdate() {
        print("Trying to perform nested updates now...")
        
        DispatchQueue.global(qos: .background).async {
            // we'll try to perform our updates
            
            // we'll first construct a custom MOC
            let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
            
            // execute updates on privateContext now
            
            let request: NSFetchRequest<Company> = Company.fetchRequest()
            request.fetchLimit = 1
            
            do {
                let companies = try privateContext.fetch(request)
                companies.forEach({ (company) in
                    print(company.name ?? "")
                    company.name = "D: \(company.name ?? "")"
                })
                do {
                    try privateContext.save()
                    // after save succeeds
                    DispatchQueue.main.async {
                        do {
                            let context = CoreDataManager.shared.persistentContainer.viewContext
                            if context.hasChanges {
                                try context.save()
                            }
                            self.tableViewCompanyList.reloadData()
                        } catch let finalSaveErr {
                            print("Failed to save main context:", finalSaveErr)
                        }
                    }
                } catch let saveErr {
                    print("Failed to save on private context:", saveErr)
                }
            } catch let fetchErr {
                print("Failed to fetch on private context:", fetchErr)
            }
        }
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
