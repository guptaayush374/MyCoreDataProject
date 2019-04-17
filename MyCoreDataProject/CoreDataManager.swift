//
//  CoreDataManager.swift
//  MyCoreDataProject
//
//  Created by Shahanshah Manzoor on 10/04/19.
//  Copyright © 2019 Simpliv LLC. All rights reserved.
//

import CoreData

struct CoreDataManager {
    
    // will live forever as long as your application is still alive, it's properties will too...
     static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "MyCoreDataProject")
        container.loadPersistentStores { (storeDescription, error) in
            if let err = error {
                fatalError("Loading of store failed: \(err)")
            }
        }
        return container
    }()
    
    func fetchCompanies() -> [Company] {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        
        do {
            let companies = try context.fetch(fetchRequest)
            return companies
        } catch let fetchErr {
            print("Failed to fetch companies: ", fetchErr)
            return []
        }
    }
}
