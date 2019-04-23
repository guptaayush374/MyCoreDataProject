//
//  CompaniesAutoUpdateController.swift
//  IntermediateTraining
//
//  Created by Brian Voong on 11/8/17.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit
import CoreData

class CompaniesAutoUpdateController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableViewCompany: UITableView! {
        didSet {
            tableViewCompany.register(UINib(nibName: "CompanyTVCell", bundle: nil), forCellReuseIdentifier: "CompanyTVCell")
        }
    }
    
    // warning: this code here is going to be a bit of a monster
    lazy var fetchedResultsController: NSFetchedResultsController<Company> = {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let request: NSFetchRequest<Company> = Company.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "name", cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch let err {
            print(err)
        }
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Service.shared.downloadCompaniesFromServer()
        
        navigationItem.title = "Company Auto Updates"
        
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAdd)),
            UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(handleDelete))
        ]
        
        self.tableViewCompany.backgroundColor = UIColor.darkBlue
        
        fetchedResultsController.fetchedObjects?.forEach({ (company) in
            print(company.name ?? "")
        })
        
        self.tableViewCompany.dataSource = self
        self.tableViewCompany.delegate = self
        
        self.tableViewCompany.reloadData()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableViewCompany.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            self.tableViewCompany.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            self.tableViewCompany.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            self.tableViewCompany.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            self.tableViewCompany.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            self.tableViewCompany.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            self.tableViewCompany.moveRow(at: indexPath!, to: newIndexPath!)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableViewCompany.endUpdates()
    }
    
    @objc private func handleAdd() {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let company = Company(context: context)
        company.name = "Micro"
        
        try? context.save()
    }
    
    @objc func handleDelete() {
        
        let request: NSFetchRequest<Company> = Company.fetchRequest()
        
        request.predicate = NSPredicate(format: "name CONTAINS %@", "M")
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let companiesWithB = try? context.fetch(request)
        
        companiesWithB?.forEach { (company) in
            context.delete(company)
        }
        
        try? context.save()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = fetchedResultsController.sectionIndexTitles[section]
        label.backgroundColor = UIColor.lightBlue
        return label
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyTVCell", for: indexPath) as! CompanyTVCell
        let company = fetchedResultsController.object(at: indexPath)
        cell.company = company
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EmployeesViewController") as! EmployeesViewController
        vc.company = fetchedResultsController.object(at: indexPath)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
