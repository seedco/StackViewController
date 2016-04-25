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
    private struct Appearance {
        static let LabelTextColor = UIColor(white: 0.56, alpha: 1.0)
        static let FieldTextColor = UIColor.blackColor()
        static let Font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    }
    
    private struct Layout {
        static let EdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        static let StackViewSpacing: CGFloat = 15
    }
    
    private let label: UILabel
    private let textField: UITextField
    
    init(labelText: String) {
        label = UILabel(frame: CGRectZero)
        label.textColor = Appearance.LabelTextColor
        label.font = Appearance.Font
        label.text = labelText
        label.setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: .Horizontal)
        
        textField = UITextField(frame: CGRectZero)
        textField.textColor = Appearance.FieldTextColor
        textField.font = Appearance.Font
        
        super.init(frame: CGRectZero)
        
        let stackView = UIStackView(arrangedSubviews: [label, textField])
        stackView.axis = .Horizontal
        stackView.spacing = Layout.StackViewSpacing
        
        addSubview(stackView)
        stackView.activateSuperviewHuggingConstraints(insets: Layout.EdgeInsets)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
