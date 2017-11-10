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
    fileprivate let stackViewController: StackViewController
    fileprivate var firstField: UIView?
    fileprivate var bodyTextView: UITextView?
    
    init() {
        stackViewController = StackViewController()
        stackViewController.separatorViewFactory = StackViewContainer.createSeparatorViewFactory()
        
        super.init(nibName: nil, bundle: nil)
        
        edgesForExtendedLayout = UIRectEdge()
        title = "Send Message"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send", style: .done, target: self, action: #selector(ViewController.send(_:)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView(frame: CGRect.zero)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.didTapView)))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStackViewController()
        displayStackViewController()
    }
    
    fileprivate func setupStackViewController() {
        let toFieldController = LabeledTextFieldController(labelText: "To:")
        firstField = toFieldController.view
        stackViewController.addItem(toFieldController)
        stackViewController.addItem(LabeledTextFieldController(labelText: "Subject:"))
        
        let textView = UITextView(frame: CGRect.zero)
        textView.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 0, right: 10)
        textView.text = "This field automatically expands as you type, no additional logic required"
        stackViewController.addItem(textView, canShowSeparator: false)
        bodyTextView = textView
        
        stackViewController.addItem(ImageAttachmentViewController())
    }
    
    fileprivate func displayStackViewController() {
        addChildViewController(stackViewController)
        view.addSubview(stackViewController.view)
        _ = stackViewController.view.activateSuperviewHuggingConstraints()
        stackViewController.didMove(toParentViewController: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        firstField?.becomeFirstResponder()
    }
    
    // MARK: Actions
    
    @objc fileprivate func send(_ sender: UIBarButtonItem) {}
    
    @objc fileprivate func didTapView(_ gestureRecognizer: UIGestureRecognizer) {
        bodyTextView?.becomeFirstResponder()
    }
}
