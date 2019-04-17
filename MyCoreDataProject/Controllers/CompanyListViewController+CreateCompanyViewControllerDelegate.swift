//
//  CompanyController+CreateCompany.swift
//  MyCoreDataProject
//
//  Created by Shahanshah Manzoor on 16/04/19.
//  Copyright © 2019 Simpliv LLC. All rights reserved.
//

import UIKit

extension CompanyListViewController: CreateCompanyViewControllerDelegate {
    
    func disAddCompany(company: Company) {
        self.addCompany(with: company)
    }
    
    func didEditCompany(company: Company) {
        guard let row = self.companies.firstIndex(of: company) else { return }
        let reloadIndexPath = IndexPath(row: row, section: 0)
        self.tableViewCompanyList.reloadRows(at: [reloadIndexPath], with: .automatic)
    }
}
