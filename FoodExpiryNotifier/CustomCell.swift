//
//  CustomCell.swift
//  FoodExpiryNotifier
//
//  Created by Simran Singh Sandhu on 09/06/20.
//  Copyright © 2020 Simran Singh Sandhu. All rights reserved.
//

import UIKit

protocol infoButtonDelegate {
    // Delegate Functions of Info Button (RightView) with a parameter of TextField.
    func showInfo(textField: UITextField)
}

class CustomCell: UITableViewCell {

    // Instance of the Protocol
    var infoDelegate: infoButtonDelegate!
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter new Item..."
        textField.clipsToBounds = true
        textField.rightViewMode = .whileEditing
        textField.font = UIFont.boldSystemFont(ofSize: 24)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textRect(forBounds: CGRect(x: 0, y: 1, width: 0, height: 0), limitedToNumberOfLines: 0)
        label.alpha = 0.75
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(nameTextField)
        addSubview(dateLabel)
        
        settingConstraints()
        
        settingRightView()
        
        layoutIfNeeded()
    }
    
    // Setting up the Right View of the TextField.
    private func settingRightView() {
        let infoBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 75, height: 75))
        infoBtn.addTarget(self, action: #selector(infoBtnHandle), for: .touchUpInside)
        infoBtn.backgroundColor = UIColor.systemBlue
        nameTextField.rightView = infoBtn
    }
    
    @objc func infoBtnHandle(){
        // When Info Button (Right View)is pressed on TextField
        infoDelegate.showInfo(textField: nameTextField)
    }
    
    private func settingConstraints() {
        
        let padding: CGFloat = 10

        nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding).isActive = true
        nameTextField.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
//        nameTextField.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: 0).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding).isActive = true
        
        dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding).isActive = true
        dateLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 5).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding).isActive = true
        
    }
}
