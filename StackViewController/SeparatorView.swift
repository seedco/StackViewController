//
//  SeparatorView.swift
//  StackViewController
//
//  Created by Indragie Karunaratne on 2016-04-12.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit

/// A customizable separator view that can be displayed in horizontal and
/// vertical orientations.
open class SeparatorView: UIView {
    fileprivate var sizeConstraint: NSLayoutConstraint?
    
    /// The thickness of the separator. This is equivalent to the height for
    /// a horizontal separator and the width for a vertical separator.
    open var separatorThickness: CGFloat = 1.0 {
        didSet {
            sizeConstraint?.constant = separatorThickness
            setNeedsDisplay()
        }
    }
    
    /// The inset of the separator from the left (MinX) edge for a horizontal
    /// separator and from the bottom (MaxY) edge for a vertical separator.
    open var separatorInset: CGFloat = 15.0 {
        didSet { setNeedsDisplay() }
    }
    
    /// The color of the separator
    open var separatorColor = UIColor(white: 0.90, alpha: 1.0) {
        didSet { setNeedsDisplay() }
    }
    
    /// The axis (horizontal or vertical) of the separator
    open var axis = NSLayoutConstraint.Axis.horizontal {
        didSet { updateSizeConstraint() }
    }
    
    /// Initializes the receiver for display on the specified axis.
    public init(axis: NSLayoutConstraint.Axis) {
        self.axis = axis
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func updateSizeConstraint() {
        sizeConstraint?.isActive = false
        let layoutAttribute: NSLayoutConstraint.Attribute = {
            switch axis {
            case .horizontal: return .height
            case .vertical: return .width
            }
        }()
        sizeConstraint = NSLayoutConstraint(
            item: self,
            attribute: layoutAttribute,
            relatedBy: .equal,
            toItem: nil, attribute:
            .notAnAttribute,
            multiplier: 1.0,
            constant: separatorThickness
        )
        sizeConstraint?.isActive = true
    }
    
    fileprivate func commonInit() {
        backgroundColor = .clear
        updateSizeConstraint()
    }
    
    open override func draw(_ rect: CGRect) {
        guard separatorThickness > 0 else { return }
        let edge: CGRectEdge = {
            switch axis {
            case .horizontal: return .minXEdge
            case .vertical: return .maxYEdge
            }
        }()
        let (_, separatorRect) = bounds.divided(atDistance: separatorInset, from: edge)
        separatorColor.setFill()
        UIRectFill(separatorRect)
    }
}
