//
//  ViewControllerConvertible.swift
//  Seed
//
//  Created by Indragie Karunaratne on 1/29/16.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit

public protocol StackViewItem: AnyObject {
    func toViewController() -> UIViewController
}

extension UIViewController: StackViewItem {
    public func toViewController() -> UIViewController {
        return self
    }
}

extension UIView: StackViewItem {
    public func toViewController() -> UIViewController {
        return WrapperViewController(view: self)
    }
}

private class WrapperViewController: UIViewController {
    fileprivate let _view: UIView
    
    init(view: UIView) {
        _view = view
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate override func loadView() {
        view = _view
    }
}
