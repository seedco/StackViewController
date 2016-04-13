//
//  NSLayoutConstraint+Seed.swift
//  StackViewController
//
//  Created by Indragie Karunaratne on 2016-04-11.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    public class func superviewHuggingConstraintsForView(view: UIView) -> [NSLayoutConstraint] {
        let views = ["view": view]
        var constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: [], metrics: nil, views: views)
        constraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: [], metrics: nil, views: views))
        return constraints
    }
}
