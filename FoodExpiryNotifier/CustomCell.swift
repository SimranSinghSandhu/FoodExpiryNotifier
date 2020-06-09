//
//  CustomCell.swift
//  FoodExpiryNotifier
//
//  Created by Simran Singh Sandhu on 09/06/20.
//  Copyright © 2020 Simran Singh Sandhu. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.boldSystemFont(ofSize: 24)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(nameTextField)
        settingConstraints()
        layoutIfNeeded()
    }
    
    
    private func settingConstraints() {
        nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        nameTextField.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nameTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
}
