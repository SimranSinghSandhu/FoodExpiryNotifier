//
//  DatePickerVIewController.swift
//  FoodExpiryNotifier
//
//  Created by Simran Singh Sandhu on 14/06/20.
//  Copyright © 2020 Simran Singh Sandhu. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {
    
    var indexPath: Int?
    var datePicker = UIDatePicker()

    let dateTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.boldSystemFont(ofSize: 24)
        textField.textAlignment = .center
        textField.placeholder = "Enter Expiry Date"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightGray
        view.addSubview(dateTextField)
        
        settingCostraints()
        
        createDatePicker()
    }
    
    private func settingCostraints() {
        dateTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        dateTextField.heightAnchor.constraint(equalToConstant: 75).isActive = true
        dateTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        dateTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
    }
    
}

extension DatePickerViewController {
    
    private func createDatePicker() {
        // Creating toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Creating Bar Button
        let barButton = UIBarButtonItem(title: "Sone", style: .done, target: self, action: #selector(barBtnHandle))
        toolbar.setItems([barButton], animated: true) // Assinging Bar Button to Toolbar
        
        // Assinging toolbar to TextField
        dateTextField.inputAccessoryView = toolbar
        
        // Assigning Date Picker to TextField
        dateTextField.inputView = datePicker
        
        // Date Picker Mode
        datePicker.datePickerMode = .date
    }
    
    @objc func barBtnHandle() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        guard let indexPath = indexPath else {return}
        
        let newItem = Item()
        newItem.date = datePicker.date
        items.insert(newItem, at: indexPath)
        
        print("Name =", newItem.name)
        print("Date =", newItem.date)
        
        dateTextField.text = formatter.string(from: datePicker.date)
        
        dateTextField.endEditing(true)
        
        
    }
}
