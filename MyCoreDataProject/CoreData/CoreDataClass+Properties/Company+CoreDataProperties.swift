//
//  Company+CoreDataProperties.swift
//  MyCoreDataProject
//
//  Created by Shahanshah Manzoor on 22/04/19.
//  Copyright © 2019 Simpliv LLC. All rights reserved.
//
//

import Foundation
import CoreData


extension Company {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Company> {
        return NSFetchRequest<Company>(entityName: "Company")
    }

    @NSManaged public var founded: String?
    @NSManaged public var imageData: Data?
    @NSManaged public var name: String?
    @NSManaged public var employees: NSSet?

}

// MARK: Generated accessors for employees
extension Company {

    @objc(addEmployeesObject:)
    @NSManaged public func addToEmployees(_ value: Employee)

    @objc(removeEmployeesObject:)
    @NSManaged public func removeFromEmployees(_ value: Employee)

    @objc(addEmployees:)
    @NSManaged public func addToEmployees(_ values: NSSet)

    @objc(removeEmployees:)
    @NSManaged public func removeFromEmployees(_ values: NSSet)

}
