//
//  AutoscrollContainerView.swift
//  Seed
//
//  Created by Indragie Karunaratne on 2016-03-10.
//
//

import UIKit

/// A scroll view that automatically scrolls to a subview of its `contentView`
/// when the keyboard is shown. This replicates the behaviour implemented by
/// `UITableView`.
public class AutoscrollContainerView: UIScrollView {
    private struct Constants {
        static let DefaultAnimationDuration: NSTimeInterval = 0.25
        static let DefaultAnimationCurve = UIViewAnimationCurve.EaseInOut
        static let ScrollAnimationID = "AutoscrollAnimation"
    }
    private var _contentView: UIView?
    public var contentView: UIView? {
        get { return _contentView }
        set {
            if let contentView = _contentView {
                contentView.removeFromSuperview()
            }
            _contentView = newValue
            if let contentView = _contentView {
                contentView.translatesAutoresizingMaskIntoConstraints = false
                addSubview(contentView)
                let constraints = NSLayoutConstraint.superviewHuggingConstraintsForView(contentView)
                NSLayoutConstraint.activateConstraints(constraints)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        showsVerticalScrollIndicator = false
        alwaysBounceVertical = true
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(AutoscrollContainerView.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        nc.addObserver(self, selector: #selector(AutoscrollContainerView.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: Notifications
    
    // Implementation based on code from Apple documentation
    // https://developer.apple.com/library/ios/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html
    @objc private func keyboardWillShow(notification: NSNotification) {
        let keyboardFrameValue = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue
        guard let keyboardSize = keyboardFrameValue?.CGRectValue().size else { return }
        
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        self.contentInset = contentInset
        scrollIndicatorInsets = contentInset
        
        guard let firstResponder = firstResponder else { return }
        let firstResponderFrame = firstResponder.convertRect(firstResponder.bounds, toView: self)
        
        var contentBounds = CGRect(origin: contentOffset, size: bounds.size)
        contentBounds.size.height -= keyboardSize.height
        if !contentBounds.contains(firstResponderFrame.origin) {
            let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSTimeInterval ?? Constants.DefaultAnimationDuration
            let curve = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? UIViewAnimationCurve ?? Constants.DefaultAnimationCurve
            
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
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        contentInset = UIEdgeInsetsZero
        scrollIndicatorInsets = UIEdgeInsetsZero
    }
}

private extension UIView {
    var firstResponder: UIView? {
        if isFirstResponder() {
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
