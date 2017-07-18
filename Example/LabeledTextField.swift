//
//  LabeledTextField.swift
//  StackViewController
//
//  Created by Indragie Karunaratne on 2016-04-24.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit
import StackViewController

class LabeledTextField: UIView {
    fileprivate struct Appearance {
        static let LabelTextColor = UIColor(white: 0.56, alpha: 1.0)
        static let FieldTextColor = UIColor.black
        static let Font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
    }
    
    fileprivate struct Layout {
        static let EdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        static let StackViewSpacing: CGFloat = 10
    }
    
    let label: UILabel
    let textField: UITextField
    
    init(labelText: String) {
        label = UILabel(frame: CGRect.zero)
        label.textColor = Appearance.LabelTextColor
        label.font = Appearance.Font
        label.text = labelText
        label.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        
        textField = UITextField(frame: CGRect.zero)
        textField.textColor = Appearance.FieldTextColor
        textField.font = Appearance.Font
        
        super.init(frame: CGRect.zero)
        
        let stackView = UIStackView(arrangedSubviews: [label, textField])
        stackView.axis = .horizontal
        stackView.spacing = Layout.StackViewSpacing
        
        addSubview(stackView)
        _ = stackView.activateSuperviewHuggingConstraints(insets: Layout.EdgeInsets)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
        return false
    }
}
