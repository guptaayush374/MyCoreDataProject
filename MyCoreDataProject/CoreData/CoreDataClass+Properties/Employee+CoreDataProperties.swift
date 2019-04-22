//
//  Employee+CoreDataProperties.swift
//  MyCoreDataProject
//
//  Created by Shahanshah Manzoor on 22/04/19.
//  Copyright © 2019 Simpliv LLC. All rights reserved.
//
//

import Foundation
import CoreData


extension Employee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee")
    }

    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var employeeInfo: EmployeeInfo?
    @NSManaged public var address: Address?
    @NSManaged public var company: Company?

}
