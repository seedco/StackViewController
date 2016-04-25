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
    private var firstField: UIView?
    private var bodyTextView: UITextView?
    
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
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.didTapView)))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStackViewController()
        displayStackViewController()
    }
    
    private func setupStackViewController() {
        let toFieldController = LabeledTextFieldController(labelText: "To:")
        firstField = toFieldController.view
        stackViewController.addItem(toFieldController)
        stackViewController.addItem(LabeledTextFieldController(labelText: "Subject:"))
        
        let textView = UITextView(frame: CGRectZero)
        textView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        textView.scrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
        textView.text = "This field automatically expands as you type, no additional logic required"
        stackViewController.addItem(textView)
        bodyTextView = textView
        
        stackViewController.addItem(ImageAttachmentViewController(nibName: nil, bundle: nil))
    }
    
    private func displayStackViewController() {
        addChildViewController(stackViewController)
        view.addSubview(stackViewController.view)
        stackViewController.view.activateSuperviewHuggingConstraints()
        stackViewController.didMoveToParentViewController(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        firstField?.becomeFirstResponder()
    }
    
    @objc private func didTapView(gestureRecognizer: UIGestureRecognizer) {
        bodyTextView?.becomeFirstResponder()
    }
}
