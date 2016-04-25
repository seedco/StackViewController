//
//  UIView+Seed.swift
//  StackViewController
//
//  Created by Indragie Karunaratne on 2016-04-24.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit

extension UIView {
    public func activateSuperviewHuggingConstraints() -> [NSLayoutConstraint] {
        let views = ["view": self]
        var constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: [], metrics: nil, views: views)
        constraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(constraints)
        return constraints
    }
}
