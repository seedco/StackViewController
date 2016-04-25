//
//  UIView+Seed.swift
//  StackViewController
//
//  Created by Indragie Karunaratne on 2016-04-24.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit

extension UIView {
    public func activateSuperviewHuggingConstraints(insets insets: UIEdgeInsets = UIEdgeInsetsZero) -> [NSLayoutConstraint] {
        let views = ["view": self]
        let metrics = ["top": insets.top, "left": insets.left, "bottom": insets.bottom, "right": insets.right]
        var constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-left-[view]-right-|", options: [], metrics: metrics, views: views)
        constraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat("V:|-top-[view]-bottom-|", options: [], metrics: metrics, views: views))
        NSLayoutConstraint.activateConstraints(constraints)
        return constraints
    }
}
