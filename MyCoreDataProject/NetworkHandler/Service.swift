//
//  Service.swift
//  IntermediateTraining
//
//  Created by Brian Voong on 11/9/17.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import Foundation
import CoreData

struct Service {
    
    static let shared = Service()
    
    let urlString = "https://api.letsbuildthatapp.com/intermediate_training/companies"
    
    func downloadCompaniesFromServer() {
        print("Attempting to download companies..")
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            
            print("Finished downloading")
            
            if let err = err {
                print("Failed to download companies:", err)
                return
            }
            
            guard let data = data else { return }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                // i'll leave a link in the bottom if you want more details on how JSON Decodable works
                let jsonCompanies = try jsonDecoder.decode([JSONCompany].self, from: data)
                
                let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                
                privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
                
                // Companies...
                jsonCompanies.forEach({ (jsonCompany) in
                    print(jsonCompany.name)
                    
                    let company = Company(context: privateContext)
                    company.name = jsonCompany.name
                    company.founded = jsonCompany.founded
                    
                    // Employees...
                    jsonCompany.employees?.forEach({ (jsonEmployee) in
                        print("  \(jsonEmployee.name)")
                        
                        let employee = Employee(context: privateContext)
                        employee.name = jsonEmployee.name
                        employee.type = jsonEmployee.type
                        
                        let employeeInfo = EmployeeInfo(context: privateContext)
                        employeeInfo.birthday = jsonEmployee.birthday
                        employee.employeeInfo = employeeInfo
                        employee.company = company
                    })
                    
                    do {
                        try privateContext.save()
                        try privateContext.parent?.save()
                        
                    } catch let saveErr {
                        print("Failed to save companies:", saveErr)
                    }
                })
                
            } catch let jsonDecodeErr {
                print("Failed to decode:", jsonDecodeErr)
            }
            }.resume() // please do not forget to make this call
    }
}

struct JSONCompany: Decodable {
    
    let name: String
    let founded: String
    var employees: [JSONEmployee]?
}

struct JSONEmployee: Decodable {
    let name: String
    let type: String
    let birthday: String
}
