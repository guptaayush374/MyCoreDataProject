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
                
                jsonCompanies.forEach({ (jsonCompany) in
                    print(jsonCompany.name)
                    
                    let company = Company(context: privateContext)
                    company.name = jsonCompany.name
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    let foundedDate = dateFormatter.date(from: jsonCompany.founded)
                    
                    company.founded = foundedDate
                    
                    do {
                        try privateContext.save()
                        try privateContext.parent?.save()
                    } catch let err {
                        print("Failed to save companies: ", err)
                    }
                    
                    jsonCompany.employees?.forEach({ (jsonEmployee) in
                        print("  \(jsonEmployee.name)")
                    })
                })
            } catch let jsonDecodeErr {
                print("Failed to decode:", jsonDecodeErr)
            }
            //            let string = String(data: data, encoding: .utf8)
            //            print(string)
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
