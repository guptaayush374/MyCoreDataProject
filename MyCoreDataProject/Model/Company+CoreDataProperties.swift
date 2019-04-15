//
//  Company+CoreDataProperties.swift
//  MyCoreDataProject
//
//  Created by Shahanshah Manzoor on 15/04/19.
//  Copyright © 2019 Simpliv LLC. All rights reserved.
//
//

import Foundation
import CoreData


extension Company {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Company> {
        return NSFetchRequest<Company>(entityName: "Company")
    }

    @NSManaged public var name: String?
    @NSManaged public var founded: String?
    @NSManaged public var imageData: Data?

}
