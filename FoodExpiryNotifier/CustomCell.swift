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
        textField.placeholder = "Enter new Item..."
        
        textField.clipsToBounds = true
        textField.rightViewMode = .whileEditing
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
        
        settingRightView()
        
        layoutIfNeeded()
    }
    
    private func settingRightView() {
        let infoBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 75, height: 75))
        infoBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        infoBtn.addTarget(self, action: #selector(infoBtnHandle), for: .touchUpInside)
        infoBtn.backgroundColor = UIColor.systemBlue
        nameTextField.rightView = infoBtn
    }
    
    @objc func infoBtnHandle(){
        print("Info button is pressed!")
    }
    
    private func settingConstraints() {
        
        let width = UIScreen.main.bounds.size.width
        let padding: CGFloat = 20

        nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        nameTextField.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        nameTextField.widthAnchor.constraint(equalToConstant: width - padding).isActive = true
        
    }
}
