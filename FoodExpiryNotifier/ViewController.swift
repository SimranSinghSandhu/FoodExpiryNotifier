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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CustomCell
        
        cell.nameLabel.text = "Batman"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
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
    }
    
}
