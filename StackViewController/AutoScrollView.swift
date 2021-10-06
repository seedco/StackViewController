//
//  AutoScrollView.swift
//  Seed
//
//  Created by Indragie Karunaratne on 2016-03-10.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit

/// A scroll view that automatically scrolls to a subview of its `contentView`
/// when the keyboard is shown. This replicates the behaviour implemented by
/// `UITableView`.
open class AutoScrollView: UIScrollView {
    fileprivate struct Constants {
        static let DefaultAnimationDuration: TimeInterval = 0.25
        static let DefaultAnimationCurve = UIView.AnimationCurve.easeInOut
        static let ScrollAnimationID = "AutoscrollAnimation"
    }
    
    /// The content view to display inside the container view. Views can also
    /// be added directly to this view without using the `contentView` property,
    /// but it simply makes it more convenient for the common case where your
    /// content fills the bounds of the scroll view.
    open var contentView: UIView? {
        willSet {
            contentView?.removeFromSuperview()
        }
        didSet {
            if let contentView = contentView {
                contentView.translatesAutoresizingMaskIntoConstraints = false
                addSubview(contentView)
                updateContentViewConstraints()
            }
        }
    }
    fileprivate var contentViewConstraints: [NSLayoutConstraint]?
    
    /// This layout guide follows the `contentView` and honors the `horizontallyCompactContentWidth`
    /// and `horizontallyRegularContentWidth` values.
    public var contentViewLayoutGuide = UILayoutGuide()
    private var contentViewLayoutGuideConstraints: [NSLayoutConstraint] = []
    
    /// This setting determines how the content should be laid out in a horizontally compact environment.
    public var horizontallyCompactContentWidth: ContentWidth = .matchScrollViewWidth {
        didSet {
            guard horizontallyCompactContentWidth != oldValue else { return }
            
            switch traitCollection.horizontalSizeClass {
            case .compact: updateContentViewConstraints()
            case .regular, .unspecified: break // no-op
            @unknown default: break
            }
        }
    }
    
    /// This setting determines how the content should be laid out in a horizontally regular environment.
    public var horizontallyRegularContentWidth: ContentWidth = .matchScrollViewWidth {
        didSet {
            guard horizontallyRegularContentWidth != oldValue else { return }
            
            switch traitCollection.horizontalSizeClass {
            case .regular: updateContentViewConstraints()
            case .compact, .unspecified: break // no-op
            @unknown default: break
            }
        }
    }
    
    override open var contentInset: UIEdgeInsets {
        didSet {
            updateContentViewConstraints()
        }
    }
    
    fileprivate func updateContentViewConstraints() {
        let contentViewFollowsReadableWidth: Bool
        switch traitCollection.horizontalSizeClass {
        case .compact:
            switch horizontallyCompactContentWidth {
            case .matchScrollViewWidth:
                contentViewFollowsReadableWidth = false
            case .matchReadableContentGuideWidth:
                contentViewFollowsReadableWidth = true
            }
            
        case .regular:
            switch horizontallyRegularContentWidth {
            case .matchScrollViewWidth:
                contentViewFollowsReadableWidth = false
            case .matchReadableContentGuideWidth:
                contentViewFollowsReadableWidth = true
            }
            
        case .unspecified:
            return // abort early
            
        @unknown default:
            contentViewFollowsReadableWidth = false
        }
        
        if let constraints = contentViewConstraints {
            NSLayoutConstraint.deactivate(constraints)
        }
        NSLayoutConstraint.deactivate(contentViewLayoutGuideConstraints)
        
        let newLayoutGuide: UILayoutGuide
        if contentViewFollowsReadableWidth, let contentView = contentView {
            let newConstraints = [
                contentView.leadingAnchor.constraint(
                    equalTo: readableContentGuide.leadingAnchor,
                    constant: contentInset.left
                ),
                contentView.trailingAnchor.constraint(
                    equalTo: readableContentGuide.trailingAnchor,
                    constant: -contentInset.right
                ),
                contentView.topAnchor.constraint(equalTo: topAnchor, constant: contentInset.top),
                contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -contentInset.bottom),
            ]
            NSLayoutConstraint.activate(newConstraints)
            contentViewConstraints = newConstraints
            
            newLayoutGuide = readableContentGuide
        } else {
            contentViewConstraints = contentView?.activateSuperviewHuggingConstraints(insets: contentInset)
            
            newLayoutGuide = frameLayoutGuide
        }
        
        contentViewLayoutGuideConstraints = [
            contentViewLayoutGuide.leadingAnchor.constraint(equalTo: newLayoutGuide.leadingAnchor),
            contentViewLayoutGuide.topAnchor.constraint(equalTo: newLayoutGuide.topAnchor),
            contentViewLayoutGuide.trailingAnchor.constraint(equalTo: newLayoutGuide.trailingAnchor),
            contentViewLayoutGuide.bottomAnchor.constraint(equalTo: newLayoutGuide.bottomAnchor),
        ]
        NSLayoutConstraint.activate(contentViewLayoutGuideConstraints)
    }
    
    fileprivate func commonInit() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(AutoScrollView.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.addObserver(self, selector: #selector(AutoScrollView.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        addLayoutGuide(contentViewLayoutGuide)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    open override func touchesShouldCancel(in view: UIView) -> Bool {
        guard view.isKind(of: UIButton.self) else { return super.touchesShouldCancel(in: view) }
        return true
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard traitCollection.horizontalSizeClass != previousTraitCollection?.horizontalSizeClass else {
            return
        }
        
        updateContentViewConstraints()
    }
    
    // MARK: Notifications
    
    // Implementation based on code from Apple documentation
    // https://developer.apple.com/library/ios/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html
    @objc fileprivate func keyboardWillShow(_ notification: Notification) {
        let keyboardFrameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        guard var keyboardFrame = keyboardFrameValue?.cgRectValue else { return }
        keyboardFrame = convert(keyboardFrame, from: nil)
        
        let bottomInset: CGFloat
        let keyboardIntersectionRect = bounds.intersection(keyboardFrame)
        if !keyboardIntersectionRect.isNull {
            bottomInset = keyboardIntersectionRect.height
            let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
            super.contentInset = contentInset
            scrollIndicatorInsets = contentInset
        } else {
            bottomInset = 0.0
        }
        
        guard let firstResponder = firstResponder else { return }
        let firstResponderFrame = firstResponder.convert(firstResponder.bounds, to: self)
        
        var contentBounds = CGRect(origin: contentOffset, size: bounds.size)
        contentBounds.size.height -= bottomInset
        if !contentBounds.contains(firstResponderFrame.origin) {
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? Constants.DefaultAnimationDuration
            let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UIView.AnimationCurve ?? Constants.DefaultAnimationCurve
            
            // Dropping down to the old style UIView animation API because the new API
            // does not support setting the curve directly. The other option is to take
            // `curve` and shift it left by 16 bits to turn it into a `UIViewAnimationOptions`,
            // but that seems uglier than just doing this.
            UIView.beginAnimations(Constants.ScrollAnimationID, context: nil)
            UIView.setAnimationCurve(curve)
            UIView.setAnimationDuration(duration)
            scrollRectToVisible(firstResponderFrame, animated: false)
            UIView.commitAnimations()
        }
    }
    
    @objc fileprivate func keyboardWillHide(_ notification: Notification) {
        super.contentInset = UIEdgeInsets.zero
        scrollIndicatorInsets = UIEdgeInsets.zero
    }
}

private extension UIView {
    var firstResponder: UIView? {
        if isFirstResponder {
            return self
        }
        for subview in subviews {
            if let responder = subview.firstResponder {
                return responder
            }
        }
        return nil
    }
}
