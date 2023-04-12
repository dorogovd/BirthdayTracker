//
//  ViewController.swift
//  BirthdayTracker
//
//  Created by Dmitrii Dorogov on 05.04.2023.
//

import UIKit
import CoreData

class AddBirthdayViewController: UIViewController {
    
    @IBOutlet var firstNametextField: UITextField!
    @IBOutlet var lastnameTextField: UITextField!
    @IBOutlet var birthdatePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        birthdatePicker.maximumDate = Date()
    }

    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        print("Save button tapped")
        
        let firstName = firstNametextField.text ?? ""
        let lastName = lastnameTextField.text ?? ""
        print("My name is \(firstName) \(lastName).")
        
        let birthdate = birthdatePicker.date
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newBirthday = Birthday(context: context)
        newBirthday.firstName = firstName
        newBirthday.lastName = lastName
        newBirthday.birthdate = birthdate as Date
        newBirthday.birthdayId = UUID().uuidString
        
        if let uniqueId = newBirthday.birthdayId {
            print("birthdayId: \(uniqueId)")
        }
        
        do {
            try context.save()
        } catch let error {
            print("Failed to save doe to an error: \(error)")
        }
        dismiss(animated: true)
        print("Note about birthdate is created")
        print("First Name: \(firstName)")
        print("Last Name: \(lastName)")
        print("Birthdate: \(birthdate)")
    }
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

