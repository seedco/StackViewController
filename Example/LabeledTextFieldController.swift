//
//  LabeledTextFieldController.swift
//  StackViewController
//
//  Created by Indragie Karunaratne on 2016-04-24.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit

class LabeledTextFieldController: UIViewController, UITextFieldDelegate {
    fileprivate let labelText: String
    
    init(labelText: String) {
        self.labelText = labelText
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let labeledField = LabeledTextField(labelText: labelText)
        labeledField.textField.delegate = self
        view = labeledField
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
