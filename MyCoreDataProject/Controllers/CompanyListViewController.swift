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
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var tableViewCompanyList: UITableView!
    
    var companies = [Company]()
    
    //    var companies = [
    //        Company(name: "Apple", founded: Date()),
    //        Company(name: "Google", founded: Date()),
    //        Company(name: "Facebook", founded: Date()),
    //        Company(name: "Microsoft", founded: Date())
    //    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchRequest()
        
        //Service.shared.downloadCompaniesFromServer()
        view.backgroundColor = UIColor.darkBlue
        navigationItem.title = "Companies"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: #selector(handleAddCompany))
        //        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addCompany))
        
        self.tableViewCompanyList.dataSource = self
        self.tableViewCompanyList.delegate = self
        
        self.tableViewCompanyList.separatorColor = .white
        self.tableViewCompanyList.backgroundColor = UIColor.darkBlue
        
        //self.tableViewCompanyList.reloadData()
    }
    
    func fetchRequest() {
        
        // Attempt my core data fetch somehow...
        
        let persistentContainer = NSPersistentContainer(name: "MyCoreDataProject")
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let err = error {
                fatalError("Loading of store failed: \(err)")
            }
        }
        let context = persistentContainer.viewContext
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
    
    @objc func handleAddCompany() {
        print("Adding Company...")
        self.performSegue(withIdentifier: "toCreateCompany", sender: self)
    }
    
    func addCompany(with company: Company) {
        self.companies.append(company)
        print(self.companies)
        
        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        self.tableViewCompanyList.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCreateCompany" {
            let vc = segue.destination as! CreateCompanyViewController
            vc.delegate = self
        }
    }
}

extension CompanyListViewController: DataEnteredDelegate {
    
    func userDidEnterInformation(company: Company) {
        self.addCompany(with: company)
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
        
        cell.lblCompanyName.text = self.companies[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.lightBlue
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
}
