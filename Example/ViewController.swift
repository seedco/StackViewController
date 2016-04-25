//
//  ViewController.swift
//  Example
//
//  Created by Indragie Karunaratne on 2016-04-16.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit
import StackViewController

class ViewController: UIViewController {
    private let stackViewController: StackViewController
    private var firstField: LabeledTextField!
    
    init() {
        stackViewController = StackViewController()
        stackViewController.stackViewContainer.separatorViewFactory = SeparatorView.init
        super.init(nibName: nil, bundle: nil)
        edgesForExtendedLayout = .None
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView(frame: CGRectZero)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstField = LabeledTextField(labelText: "To:")
        stackViewController.addItem(firstField)
        stackViewController.addItem(LabeledTextField(labelText: "Subject:"))
        
        addChildViewController(stackViewController)
        view.addSubview(stackViewController.view)
        stackViewController.view.activateSuperviewHuggingConstraints()
        stackViewController.didMoveToParentViewController(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        firstField.textField.becomeFirstResponder()
    }
}
