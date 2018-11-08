//
//  StackViewContainer.swift
//  StackViewController
//
//  Created by Indragie Karunaratne on 2016-04-11.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit

/// A container for a `UIStackView` that adds some additional capabilities, including
/// being able to change the background color, assigning a background view, and
/// using view controller composition to display content.
open class StackViewContainer: UIView, UIScrollViewDelegate {
    /// The scroll view that is the superview of the stack view.
    public let scrollView: AutoScrollView
    
    /// The stack view. It is not safe to modify the arranged subviews directly
    /// via the stack view. The content view collection accessors on
    /// `StackViewContainer` should be used instead. It is also not safe to modify
    /// the `axis` property. `StackViewContainer.axis` should be set instead.
    public let stackView: UIStackView
    
    fileprivate let backgroundColorContainerView = UIView(frame: CGRect.zero)
    
    /// An optional background view that is shown behind the stack view. The
    /// top of the background view will be kept pinned to the top of the scroll
    /// view bounds, even when bouncing.
    open var backgroundView: UIView? {
        get { return _backgroundView }
        set {
            backgroundViewTopConstraint = nil
            _backgroundView?.removeFromSuperview()
            _backgroundView = newValue
            layoutBackgroundView()
        }
    }
    fileprivate var _backgroundView: UIView?
    fileprivate var backgroundViewTopConstraint: NSLayoutConstraint?
    
    /// The content views that are displayed inside the stack view. This array
    /// does not include separator views that are automatically inserted by
    /// the container if the `separatorViewFactory` property is set.
    ///
    /// Setting this array causes all of the existing content views in the 
    /// stack view to be removed and replaced with the new content views.
    open var contentViews: [UIView] {
        get { return _contentViews }
        set {
            _contentViews = newValue
            relayoutContent(true)
        }
    }
    fileprivate var _contentViews = [UIView]()
    
    fileprivate var items = [Item]()
    open var separatorViewFactory: SeparatorViewFactory? {
        didSet { relayoutContent(false) }
    }
    
    /// Creates a separator view factory that uses the `SeparatorView` class
    /// provided by this framework to render the view. The separator will
    /// automatically use the correct orientation based on the orientation
    /// of the stack view. The `configurator` block can be used to customize
    /// the appearance of the separator.
    public static func createSeparatorViewFactory(_ configurator: ((SeparatorView) -> Void)? = nil) -> SeparatorViewFactory {
        return { axis in
            let separatorAxis: NSLayoutConstraint.Axis = {
                switch axis {
                case .horizontal: return .vertical
                case .vertical: return .horizontal
                }
            }()
            let separatorView = SeparatorView(axis: separatorAxis)
            configurator?(separatorView)
            return separatorView
        }
    }
    
    /// The axis (direction) that content is laid out in. Setting the axis via
    /// this property instead of `stackView.axis` ensures that any separator
    /// views are recreated to account for the change in layout direction.
    open var axis: NSLayoutConstraint.Axis {
        get { return stackView.axis }
        set {
            stackView.axis = newValue
            updateSizeConstraint()
            relayoutContent(false)
        }
    }
    fileprivate var stackViewSizeConstraint: NSLayoutConstraint?
    
    open override var backgroundColor: UIColor? {
        didSet {
            scrollView.backgroundColor = backgroundColor
            backgroundColorContainerView.backgroundColor = backgroundColor
        }
    }
    
    public typealias SeparatorViewFactory = (NSLayoutConstraint.Axis) -> UIView
    
    /// Initializes an instance of `StackViewContainer` using a stack view
    /// with the default configuration, which is simply a `UIStackView` with
    /// all of its properties set to the default values except for `axis`, which
    /// is set to `.Vertical`.
    public convenience init() {
        self.init(stackView: constructDefaultStackView())
    }
    
    /// Initializes an instance of `StackViewContainer` using an existing
    /// instance of `UIStackView`. Any existing arranged subviews of the stack
    /// view are removed prior to `StackViewContainer` taking ownership of it.
    public init(stackView: UIStackView) {
        stackView.removeAllArrangedSubviews()
        self.stackView = stackView
        self.scrollView = AutoScrollView(frame: CGRect.zero)
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        stackView = constructDefaultStackView()
        scrollView = AutoScrollView(frame: CGRect.zero)
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func commonInit() {
        backgroundColorContainerView.addSubview(stackView)
        _ = stackView.activateSuperviewHuggingConstraints()
        scrollView.contentView = backgroundColorContainerView
        scrollView.delegate = self
        addSubview(scrollView)
        _ = scrollView.activateSuperviewHuggingConstraints()
        updateSizeConstraint()
    }
    
    fileprivate func updateSizeConstraint() {
        stackViewSizeConstraint?.isActive = false
        let attribute: NSLayoutConstraint.Attribute = {
            switch axis {
            case .horizontal: return .height
            case .vertical: return .width
            }
        }()
        stackViewSizeConstraint =
            NSLayoutConstraint(item: stackView, attribute: attribute, relatedBy: .equal, toItem: scrollView, attribute: attribute, multiplier: 1.0, constant: 0.0)
        stackViewSizeConstraint?.isActive = true
    }
    
    fileprivate func layoutBackgroundView() {
        guard let backgroundView = _backgroundView else { return }
        scrollView.insertSubview(backgroundView, at: 0)
        
        let constraints = backgroundView.activateSuperviewHuggingConstraints()
        for constraint in constraints {
            if constraint.firstAttribute == .top {
                backgroundViewTopConstraint = constraint
                break
            }
        }
    }
    
    // MARK: Managing Content
    
    /**
     Adds a content view to the list of content views that this container
     manages.
     
     - parameter view:             The content view to add
     - parameter canShowSeparator: See the documentation for
     `StackViewContainer.setCanShowSeparator(:forContentViewAtIndex:)` for more
     details on this parameter.
     */
    open func addContentView(_ view: UIView, canShowSeparator: Bool = true) {
        insertContentView(view, atIndex: items.endIndex, canShowSeparator: canShowSeparator)
    }
    
    /**
     Inserts a content view into the list of content views that this container
     manages.
     
     - parameter view:             The content view to insert
     - parameter index:            The index to insert the content view at, in
     the `contentViews` array
     - parameter canShowSeparator: See the documentation for
     `StackViewContainer.setCanShowSeparator(:forContentViewAtIndex:)` for more
     details on this parameter.
     */
    open func insertContentView(_ view: UIView, atIndex index: Int, canShowSeparator: Bool = true) {
        precondition(index >= items.startIndex)
        precondition(index <= items.endIndex)
        
        let stackInsertionIndex: Int
        if items.isEmpty {
            stackInsertionIndex = 0
        } else {
            let lastExistingIndex = (items.endIndex - 1)
            let lastItem = items[lastExistingIndex]
            if index == lastExistingIndex {
                // If a content view is inserted at (items.count - 1), the last
                // content item will become the final item in the list, in which
                // case its separator should be removed.
                if let separatorView = lastItem.separatorView {
                    stackView.removeArrangedSubview(separatorView)
                    lastItem.separatorView = nil
                }
                stackInsertionIndex = indexOfArrangedSubview(lastItem.contentView)
            } else if index == items.endIndex {
                // If a content view is being inserted at the end of the list, the
                // item before it should have a separator added.
                if lastItem.separatorView == nil && lastItem.canShowSeparator {
                    if let separatorView = createSeparatorView() {
                        lastItem.separatorView = separatorView
                        stackView.addArrangedSubview(separatorView)
                    }
                }
                stackInsertionIndex = stackView.arrangedSubviews.endIndex
            } else {
                stackInsertionIndex = indexOfArrangedSubview(items[index].contentView)
            }
        }
        
        let separatorView: UIView?
        // Only show the separator if the item is not the last item in the list
        if canShowSeparator && index < items.endIndex {
            separatorView = createSeparatorView()
        } else {
            separatorView = nil
        }
        
        let item = Item(
            contentView: view,
            canShowSeparator: canShowSeparator,
            separatorView: separatorView
        )
        items.insert(item, at: index)
        _contentViews.insert(view, at: index)
        stackView.insertArrangedSubview(view, at: stackInsertionIndex)
        if let separatorView = separatorView {
            stackView.insertArrangedSubview(separatorView, at: (stackInsertionIndex + 1))
        }
    }
    
    fileprivate func indexOfArrangedSubview(_ subview: UIView) -> Int {
        if let index = stackView.arrangedSubviews.index(where: { $0 === subview }) {
            return index
        } else {
            fatalError("Called indexOfArrangedSubview with subview that doesn't exist in stackView.arrangedSubviews")
        }
    }
    
    /**
     Removes a content view from the list of content views managed by this container.
     If `view` does not exist in `contentViews`, this method does nothing.
     
     - parameter view: The content view to remove
     */
    open func removeContentView(_ view: UIView) {
        guard let index = _contentViews.index(where: { $0 === view }) else { return }
        removeContentViewAtIndex(index)
    }
    
    /**
     Removes a content view from the list of content views managed by this container.
     
     - parameter index: The index of the content view to remove
     */
    open func removeContentViewAtIndex(_ index: Int) {
        precondition(index >= items.startIndex)
        precondition(index < items.endIndex)
        
        let item = items[index]
        if items.count >= 1 && index == (items.endIndex - 1) && index > 0 {
            let previousItem = items[(index - 1)]
            if let separatorView = previousItem.separatorView {
                stackView.removeArrangedSubview(separatorView)
                previousItem.separatorView = nil
            }
        }
        stackView.removeArrangedSubview(item.contentView)
        if let separatorView = item.separatorView {
            stackView.removeArrangedSubview(separatorView)
        }
        items.remove(at: index)
        let view = _contentViews.remove(at: index)
        view.removeFromSuperview()
    }
    
    /**
     Controls the visibility of the separator view that comes after a content view.
     If `view` does not exist in `contentViews`, this method does nothing.
     
     - parameter canShowSeparator: See the documentation for
     `StackViewContainer.setCanShowSeparator(:forContentViewAtIndex:)` for more
     details on this parameter.
     - parameter view:             The content view for which to set separator
     visibility.
     */
    open func setCanShowSeparator(_ canShowSeparator: Bool, forContentView view: UIView) {
        guard let index = _contentViews.index(where: { $0 === view }) else { return }
        setCanShowSeparator(canShowSeparator, forContentViewAtIndex: index)
    }
    
    /**
     Controls the visibility of the separator view that comes after a content view.
     
     - parameter canShowSeparator: Whether it is possible for the content view
     to show a separator view *after* it (i.e. to the right of the content view
     if the stack view orientation is horizontal, and to the bottom of the
     content view if the stack view orientation is vertical). A separator will
     not be shown if the content view is the last content view in the list.
     - parameter index:            The index of the content view for which to
     set separator visibility.
     */
    open func setCanShowSeparator(_ canShowSeparator: Bool, forContentViewAtIndex index: Int) {
        let item = items[index]
        if canShowSeparator
            && (index < (items.endIndex - 1))
            && item.separatorView == nil {
            if let separatorView = createSeparatorView() {
                item.separatorView = separatorView
                stackView.insertArrangedSubview(separatorView, at: (index + 1))
            }
        } else if let separatorView = item.separatorView, !canShowSeparator {
            stackView.removeArrangedSubview(separatorView)
            item.separatorView = nil
        }
    }
    
    fileprivate func relayoutContent(_ didUpdateContent: Bool) {
        let canShowSeparatorConfig: [Bool]?
        if didUpdateContent {
            canShowSeparatorConfig = nil
        } else {
            canShowSeparatorConfig = items.map { $0.canShowSeparator }
        }
        let canShowSeparator: ((Int) -> Bool) = { index in
            if let canShowSeparatorConfig = canShowSeparatorConfig {
                return canShowSeparatorConfig[index]
            } else {
                return true
            }
        }
        items.removeAll(keepingCapacity: true)
        stackView.removeAllArrangedSubviews()
        let contentViews = _contentViews
        _contentViews.removeAll(keepingCapacity: true)
        for (index, contentView) in contentViews.enumerated() {
            addContentView(contentView, canShowSeparator: canShowSeparator(index))
        }
    }
    
    fileprivate func createSeparatorView() -> UIView? {
        guard let separatorViewFactory = separatorViewFactory else { return nil }
        return separatorViewFactory(stackView.axis)
    }
    
    // MARK: UIScrollViewDelegate
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let backgroundViewTopConstraint = backgroundViewTopConstraint else { return }
        backgroundViewTopConstraint.constant = -max(-scrollView.contentOffset.y, 0)
    }
    
    // MARK: ContentContainerView
    
    fileprivate class Item {
        fileprivate let contentView: UIView
        fileprivate let canShowSeparator: Bool
        fileprivate var separatorView: UIView?
        
        init(contentView: UIView, canShowSeparator: Bool, separatorView: UIView?) {
            self.contentView = contentView
            self.canShowSeparator = canShowSeparator
            self.separatorView = separatorView
        }
    }
}

private func constructDefaultStackView() -> UIStackView {
    let stackView = UIStackView(frame: CGRect.zero)
    stackView.axis = .vertical
    return stackView
}
