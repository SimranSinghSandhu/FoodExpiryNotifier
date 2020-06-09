//
//  ViewController.swift
//  FoodExpiryNotifier
//
//  Created by Simran Singh Sandhu on 09/06/20.
//  Copyright © 2020 Simran Singh Sandhu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let cellID = "cellID"
    
    var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assigning Deletage and Datasource Functions to TableView.
        tableView.delegate = self
        tableView.dataSource = self
        
        // Registering the Cell with the Custome Class using a Unique Indentifier.
        tableView.register(CustomCell.self, forCellReuseIdentifier: cellID)
        
        settingNavigationItems()
    }
    
}

// TableView Delegates and Datasource Function
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CustomCell
        
//        cell.nameTextField.text = ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    // When Cell Loads.
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? CustomCell {
            // Latest Cell Becomes First Responder.
            cell.nameTextField.becomeFirstResponder()
        }
    }
}

extension ViewController {
    
    // Setting Up Navigation Bar Buttons
    private func settingNavigationItems() {
        let addBtn = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addBtnHandle))
        navigationItem.rightBarButtonItem = addBtn
    }
    
    // To Add new Item in the TableView.
    @objc func addBtnHandle() {
        print("Add Button Pressed!")
        addingNewItem()
    }
}

extension ViewController: UITextFieldDelegate {
    
    private func addingNewItem() {
        
        // Creating Indexpath for Inserting Cell in TableView
        let indexPath: IndexPath = [0, items.count]
        
        let newItem = Item() // Creating Instance of Items Array
        
        newItem.name = "" // Default Text
        items.append(newItem) // Appending the NewItem inside out Array of Items Object
        
        // Updating the tableView.
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
}
