//
//  EmployeeInfo+CoreDataProperties.swift
//  MyCoreDataProject
//
//  Created by Shahanshah Manzoor on 22/04/19.
//  Copyright © 2019 Simpliv LLC. All rights reserved.
//
//

import Foundation
import CoreData


extension EmployeeInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EmployeeInfo> {
        return NSFetchRequest<EmployeeInfo>(entityName: "EmployeeInfo")
    }

    @NSManaged public var txnId: String?
    @NSManaged public var birthday: String?
    @NSManaged public var employee: Employee?

}
