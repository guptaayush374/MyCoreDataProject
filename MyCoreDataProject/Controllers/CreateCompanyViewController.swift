//
//  CreateCompanyViewController.swift
//  MyCoreDataProject
//
//  Created by Netzealous on 08/04/19.
//  Copyright © 2019 Simpliv LLC. All rights reserved.
//

import UIKit
import CoreData

protocol CreateCompanyViewControllerDelegate: class {
    func disAddCompany(company: Company)
    func didEditCompany(company: Company)
}

class CreateCompanyViewController: UIViewController {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var lblFounded: UILabel!
    @IBOutlet weak var textFieldFounded: UITextField!
    @IBOutlet weak var imgProfile: UIImageView!
    
    var company: Company?
    
    weak var delegate: CreateCompanyViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpNavigationItem()
        self.imgProfile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleselectPhoto)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = self.company == nil ? "Create Company" : "Edit Company"
        
        self.textFieldName.text = self.company?.name == nil ? "" : self.company?.name
        
        self.textFieldFounded.text = self.company?.founded == nil ? "" : self.company?.founded
        
        if let imgData = company?.imageData {
            self.imgProfile?.image = UIImage(data: imgData)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.height/2
        self.imgProfile.clipsToBounds = true
        self.imgProfile.layer.borderColor = UIColor.white.cgColor
        self.imgProfile.layer.borderWidth = 2.0
    }
    
    func setUpNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
    }
    
    @objc func handleselectPhoto() {
        
        print("Select Photo")
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func handleSave() {
        
        if self.company == nil {
            self.createCompany()
        } else {
            self.updateCompany()
        }
    }
    
    @objc func handleCancel() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func createCompany() {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
        company.setValue(self.textFieldName.text, forKey: "name")
        company.setValue(self.textFieldFounded.text, forKey: "founded")
        
        if let companyImage = self.imgProfile.image {
            let imageData = companyImage.jpegData(compressionQuality: 0.8)
            company.setValue(imageData, forKey: "imageData")
        }
        
        do {
            try context.save()
            delegate?.disAddCompany(company: company as! Company)
            if (self.delegate != nil) {
                self.navigationController?.popViewController(animated: true)
            } else {
                print("Delegate is nil.")
            }
        } catch let saveErr {
            print("Failed to save company: ", saveErr)
        }
    }
    
    private func updateCompany() {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        self.company?.name = self.textFieldName.text
        self.company?.founded = self.textFieldFounded.text
        
        if let companyImage = self.imgProfile.image {
            let imageData = companyImage.jpegData(compressionQuality: 0.8)
            company?.imageData = imageData
        }
        
        do {
            try context.save()
            delegate?.didEditCompany(company: self.company!)
            if (self.delegate != nil) {
                self.navigationController?.popViewController(animated: true)
            } else {
                print("Delegate is nil.")
            }
        } catch let err {
            print("Failed to save company: ", err)
        }
    }
}

extension CreateCompanyViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.imgProfile.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imgProfile.image = originalImage
        }
        
        dismiss(animated: true, completion: nil)
    }
}
