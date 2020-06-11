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

    // Navigation Item to Add Button
    let addBtn: UIBarButtonItem = {
        let btn = UIBarButtonItem()
        btn.title = "Add"
        btn.style = .done
        btn.action = #selector(addBtnHandle)
        return btn
    }()
    
    // Navigation Item for Done Button
    let doneBtn: UIBarButtonItem = {
        let btn = UIBarButtonItem()
        btn.title = "Done"
        btn.style = .done
        btn.action = #selector(doneBtnHandle)
        return btn
    }()
    
    let cellID = "cellID"
    
    var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assigning Deletage and Datasource Functions to TableView.
        tableView.delegate = self
        tableView.dataSource = self
        
        // Registering the Cell with the Custome Class using a Unique Indentifier.
        tableView.register(CustomCell.self, forCellReuseIdentifier: cellID)
        
        addBtn.target = self
        doneBtn.target = self
        
        navigationItemSettings(btn: addBtn)
    }
    
}

// TableView Delegates and Datasource Function
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CustomCell
        // Assigning Delegates Fuctions to TextField
        cell.nameTextField.delegate = self
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
    
    // Deleting Item with Swiped Left of Cell.
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, Completion) in
            self.items.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            Completion(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension ViewController {
    
    // Setting Up Navigation Bar Buttons
    private func navigationItemSettings(btn: UIBarButtonItem) {
        navigationItem.rightBarButtonItem = btn
    }
    
    // To Add new Item in the TableView.
    @objc func addBtnHandle() {
        // When Add Button is Pressed
        addingNewItem()
        navigationItemSettings(btn: doneBtn)
    }

    @objc func doneBtnHandle() {
        // When Done Button is Presssed
        endEditing()
    }
}

// TextField Delegate Functions
extension ViewController: UITextFieldDelegate {
    
    private func addingNewItem() {
        
        // Getting the Current IndexPath.
        let indexPath: IndexPath = [0, items.count]
        
        let newItem = Item() // Creating Instance of Items Array
        
        newItem.name = "" // Default Text
        items.append(newItem) // Appending the NewItem inside out Array of Items Object
        
        // Updating the tableView.
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        navigationItemSettings(btn: doneBtn)
        
        let indexPath = getIndexPathOfSelectedTextField(textField: textField)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updatingItem(textField: textField)
        deletingEmptyCells(textField: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.text == "" { // If textField Text is Empty
            endEditing() // End TableView Editing.
        } else { // If TextField Text is Not Empty
            addingNewItem() // Add Another Item
        }
        return true
    }
    
    private func endEditing() {
        navigationItemSettings(btn: addBtn) // Setting the Navigation Settings to Defaults
        tableView.endEditing(true) // End All the Editing of TableView.
    }
}

extension ViewController {
    
    // Getting the Current IndexPath of the Selected Textfield.
    private func getIndexPathOfSelectedTextField(textField: UITextField) -> IndexPath {
        let textFieldPoint = textField.convert(textField.bounds.origin, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: textFieldPoint) {
            return indexPath
        } else {
            return [0, 0]
        }
    }
    
    // Updating Item Data according to TextField Text.
    private func updatingItem(textField: UITextField) {
        let indexPath = getIndexPathOfSelectedTextField(textField: textField)
        items[indexPath.row].name = textField.text
    }
    
    // Deleting Empty Cells
    private func deletingEmptyCells(textField: UITextField) {
        let indexPath = getIndexPathOfSelectedTextField(textField: textField)
        if items[indexPath.row].name == "" {
            items.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}
