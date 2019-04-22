//
//  Address+CoreDataProperties.swift
//  MyCoreDataProject
//
//  Created by Shahanshah Manzoor on 22/04/19.
//  Copyright © 2019 Simpliv LLC. All rights reserved.
//
//

import Foundation
import CoreData


extension Address {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Address> {
        return NSFetchRequest<Address>(entityName: "Address")
    }

    @NSManaged public var state: String?
    @NSManaged public var city: String?
    @NSManaged public var street: String?
    @NSManaged public var employee: Employee?

}
