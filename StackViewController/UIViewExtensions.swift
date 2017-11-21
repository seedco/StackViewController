//
//  UIViewExtensions.swift
//  StackViewController
//
//  Created by Indragie Karunaratne on 2016-04-24.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit

public extension UIView {
    @objc public func activateSuperviewHuggingConstraints(insets: UIEdgeInsets = UIEdgeInsets.zero) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        let views = ["view": self]
        let metrics = ["top": insets.top, "left": insets.left, "bottom": insets.bottom, "right": insets.right]
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-left-[view]-right-|", options: [], metrics: metrics, views: views)
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-top-[view]-bottom-|", options: [], metrics: metrics, views: views))
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
}
