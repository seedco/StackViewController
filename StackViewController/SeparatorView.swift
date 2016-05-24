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
public class SeparatorView: UIView {
    private var sizeConstraint: NSLayoutConstraint?
    
    /// The thickness of the separator. This is equivalent to the height for
    /// a horizontal separator and the width for a vertical separator.
    public var separatorThickness: CGFloat = 1.0 {
        didSet {
            sizeConstraint?.constant = separatorThickness
            setNeedsDisplay()
        }
    }
    
    /// The inset of the separator from the left (MinX) edge for a horizontal
    /// separator and from the bottom (MaxY) edge for a vertical separator.
    public var separatorInset: CGFloat = 15.0 {
        didSet { setNeedsDisplay() }
    }
    
    /// The color of the separator
    public var separatorColor = UIColor(white: 0.90, alpha: 1.0) {
        didSet { setNeedsDisplay() }
    }
    
    /// The axis (horizontal or vertical) of the separator
    public var axis = UILayoutConstraintAxis.Horizontal {
        didSet { updateSizeConstraint() }
    }
    
    /// Initializes the receiver for display on the specified axis.
    public init(axis: UILayoutConstraintAxis) {
        self.axis = axis
        super.init(frame: CGRectZero)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func updateSizeConstraint() {
        sizeConstraint?.active = false
        let layoutAttribute: NSLayoutAttribute = {
            switch axis {
            case .Vertical: return .Height
            case .Horizontal: return .Width
            }
        }()
        sizeConstraint = NSLayoutConstraint(
            item: self,
            attribute: layoutAttribute,
            relatedBy: .Equal,
            toItem: nil, attribute:
            .NotAnAttribute,
            multiplier: 1.0,
            constant: separatorThickness
        )
        sizeConstraint?.active = true
    }
    
    private func commonInit() {
        backgroundColor = .clearColor()
        updateSizeConstraint()
    }
    
    public override func drawRect(rect: CGRect) {
        guard separatorThickness > 0 else { return }
        let edge: CGRectEdge = {
            switch axis {
            case .Vertical: return .MinXEdge
            case .Horizontal: return .MaxYEdge
            }
        }()
        let (_, separatorRect) = bounds.divide(separatorInset, fromEdge: edge)
        separatorColor.setFill()
        UIRectFill(separatorRect)
    }
}
