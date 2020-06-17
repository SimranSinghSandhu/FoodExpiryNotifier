//
//  ViewController.swift
//  FoodExpiryNotifier
//
//  Created by Simran Singh Sandhu on 09/06/20.
//  Copyright © 2020 Simran Singh Sandhu. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
    
    // Custom View for our UIDatePicker and Toolbar.
    let pickerView: UIView = {
        let view = UIView()
        return view
    }()
    
    let cellID = "cellID" // Unique Cell Identifier.
    
    var items = [Item]()
    var loadingData: Bool = false // When Loading Items from Database.
    
    let datePicker = UIDatePicker() // Inistializing DatePicker
    let toolbar = UIToolbar() // Initializing Toolbar for DatePicker
    
    var indexNum = Int() // IndexNumber of the TextField who's RightView is Pressed.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData() // Loading Data When ViewLoads.
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)) // Getting Directery of Databse
        
        tableView.backgroundColor = UIColor.clear
        
        // Assigning Deletage and Datasource Functions to TableView.
        tableView.delegate = self
        tableView.dataSource = self
        
        // Registering the Cell with the Custome Class using a Unique Indentifier.
        tableView.register(CustomCell.self, forCellReuseIdentifier: cellID)
        
        addBtn.target = self
        doneBtn.target = self
        
        navigationItemSettings(btn: addBtn)
        settingUpDatePicker()
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }
    
}

// TableView Delegates and Datasource Function
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CustomCell
        
        
        cell.nameTextField.delegate = self // Assigning Delegates Fuctions to TextField
        cell.infoDelegate = self //Assiging Delgate Functions to InfoButton (Right View)
        
        cell.nameTextField.text = items[indexPath.row].name
        cell.dateLabel.text = items[indexPath.row].date
        
        return cell
    }

    // When Cell Loads.
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? CustomCell {
            // Latest Cell Becomes First Responder.
            if !loadingData { // Only When Items are not Loading in TableView.
                cell.nameTextField.becomeFirstResponder()
            }
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
        
        loadingData = false
        
        // Getting the Current IndexPath.
        let indexPath: IndexPath = [0, items.count]
        
        let newItem = Item(context: context) // Creating Instance of Items Array
        
        newItem.name = "" // Default Text
        newItem.date = "" // Default Date
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

// Setting Up DatePicker and Toolbar
extension ViewController {
    private func settingUpDatePicker() {
        // Setting Up UIDatePicker Properties
        datePicker.backgroundColor = UIColor.systemGray // background Color
        datePicker.datePickerMode = .date // Mode of Displaying Content

        let w = view.frame.size.width // width of the Screen
        let h = view.frame.size.height // Height of Screen
        let pickerHeight: CGFloat = 250 // DatePicker Height
        let toolbarHeight: CGFloat = 50 // Toolbar Height

        
        // Setting Default Frame Size of PickerView.
        pickerView.frame = CGRect(x: 0, y: h, width: w, height: pickerHeight + toolbarHeight) // YAxis = Height of Screen
        
        // Setting default Frame Size of Toolbar.
        toolbar.frame = CGRect(x: 0, y: 0, width: w, height: toolbarHeight)
        
        // Setting default Frame Size of DatePicker.
        datePicker.frame = CGRect(x: 0, y: toolbarHeight, width: w, height: pickerHeight)

        // Creating a Done Bar Button item for to Complete DatePicker Changes
        let doneBarBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneBarBtnHandle))

        // Creating Spacing Between Done and Cancel Button
        let flexBarBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        // Creating Cancel Bar Button Item to Cancel DatePicker Changes
        let cancelBarBtn = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelBarBtnHandle))

        // Setting Done and Cancel Button to Toolbar
        toolbar.setItems([cancelBarBtn, flexBarBtn, doneBarBtn], animated: false)

        self.view.addSubview(pickerView) // Adding PickerView as a Subview of the Main View.
        pickerView.addSubview(datePicker) // Adding DatePicker as a Subview to the View.
        pickerView.addSubview(toolbar) // Adding Toolbar as a Subview to the View.
        
    }
    
    // Animating Date PickerView
    private func animatingDatePickerView(height: CGFloat) {
        
        let screenHeight = self.view.frame.size.height // Getting Height of Screen
        let screenWidth = self.view.frame.size.width // Getting Width of Screen
        
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            // Changing PickerView Frame with a Bouncing Animation.
            // Animating Yaxis of PickerView = ScreenHeight - Height of the PickerView
            self.pickerView.frame = CGRect(x: 0, y: screenHeight - height, width: screenWidth, height: height)
            
        }, completion: nil)
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
        saveData()
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


// Calling the Delegate Function when Info button is pressed
extension ViewController: infoButtonDelegate {
    func showInfo(textField: UITextField) {
        
        // Hidding the Done Button on Navigation Bar
        navigationItem.rightBarButtonItem = nil
        
        // Resigning the Keyboard when Info Button is Pressed
        textField.resignFirstResponder()
        
        // Getting the Index Path of the TextField whos InfoBtn is pressed.
        let indexPath = getIndexPathOfSelectedTextField(textField: textField)
        indexNum = indexPath.row
        
        // Animating Date Picker and Toolbar
        animatingDatePickerView(height: 300)
    }
    
    // When Done Button is pressed on Toolbar.
    @objc func doneBarBtnHandle() {
        // Creating a Formatter to Show only date in a Medium Style Format
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        // Animating the YAxis of PickerView to be height of Screen
        animatingDatePickerView(height: 0)
        
        // Inserting Date String inside the Items array. at a particular IndexPath.Row.
        items[indexNum].date = dateFormatter.string(from: datePicker.date)
    
        // TextField Should not be Empty to get the Date Value. (Otherwise App will Crash.)
        print(items[indexNum].name, "is Going to Expire on", items[indexNum].date)
        
        // Uplading TableView when Array Value is Modified.
        tableView.beginUpdates()
        tableView.reloadRows(at: [[0, indexNum]], with: .automatic)
        tableView.endUpdates()
        
        endEditing() // Ending all the TableView Editing.
    }
    
    // When Cancel Button is Pressed on Toolbar
    @objc func cancelBarBtnHandle() {
        print("Cancel Button is Pressed.")
        animatingDatePickerView(height: 0) // Animating the YAxis of the PickerView to be = Height of the Screen.
        endEditing() // Ending all te TableView Editing.
    }
}

// Saving and Loading Data Functions
extension ViewController {
    
    // Save Data When Data Changes.
    private func saveData() {
        do {
            try context.save()
            print("Data Save Successful!")
        } catch {
            print("Error Saving Item", error.localizedDescription)
        }
    }
    
    // Loading Data When View Loads
    private func loadData() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            loadingData = true
            items = try context.fetch(request)
        } catch {
            print("Error Loading Data from Database with Error =", error.localizedDescription)
        }
    }
}
