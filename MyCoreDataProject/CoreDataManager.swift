//
//  CoreDataManager.swift
//  MyCoreDataProject
//
//  Created by Shahanshah Manzoor on 10/04/19.
//  Copyright © 2019 Simpliv LLC. All rights reserved.
//

import CoreData

struct CoreDataManager {
    
    static let shared = CoreDataManager() // will live forever as long as your application is still alive, it's properties will too...
    
    let persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "MyCoreDataProject")
        container.loadPersistentStores { (storeDescription, error) in
            if let err = error {
                fatalError("Loading of store failed: \(err)")
            }
        }
        return container
    }()
}
