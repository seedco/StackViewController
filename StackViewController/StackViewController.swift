//
//  StackViewController.swift
//  StackViewController
//
//  Created by Indragie Karunaratne on 2016-04-11.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit

/// Provides a view controller composition based API on top of the
/// `StackViewContainer` API. Instead of adding content views directly to a view,
/// view controllers that control each content view are added as child view
/// controllers via the API exposed in this class. Adding and removing these
/// child view controllers is managed automatically.
open class StackViewController: UIViewController {
    /// An optional background view that is shown behind the stack view. The
    /// top of the background view will be kept pinned to the top of the scroll
    /// view bounds, even when bouncing.
    open var backgroundView: UIView? {
        get {
            return stackViewContainer.backgroundView
        }
        set {
            stackViewContainer.backgroundView = newValue
        }
    }

    open var backgroundColor: UIColor? {
        get {
            return stackViewContainer.backgroundColor
        }
        set {
            stackViewContainer.backgroundColor = newValue
        }
    }

    /// The stack view. It is not safe to modify the arranged subviews directly
    /// via the stack view. The items collection accessors on
    /// `StackViewController` should be used instead. It is also not safe to modify
    /// the `axis` property. `StackViewController.axis` should be set instead.
    open var stackView: UIStackView {
        return stackViewContainer.stackView
    }

    /// The axis (direction) that content is laid out in. Setting the axis via
    /// this property instead of `stackView.axis` ensures that any separator
    /// views are recreated to account for the change in layout direction.
    open var axis: NSLayoutConstraint.Axis {
        get {
            return stackViewContainer.axis
        }
        set {
            stackViewContainer.axis = newValue
        }
    }

    open var separatorViewFactory: StackViewContainer.SeparatorViewFactory? {
        get {
            return stackViewContainer.separatorViewFactory
        }
        set {
            stackViewContainer.separatorViewFactory = newValue
        }
    }

    /// The scroll view that is the superview of the stack view.
    /// The scrollview automatically accommodates the keyboard. This replicates the behaviour
    /// implemented by `UITableView`.
    open var scrollView: UIScrollView {
        return stackViewContainer.scrollView
    }

    private lazy var stackViewContainer = StackViewContainer()
    
    fileprivate var _items = [StackViewItem]()
    
    /// The items displayed by this controller
    open var items: [StackViewItem] {
        get { return _items }
        set(newItems) {
            for index in _items.indices.reversed() {
                removeItemAtIndex(index)
            }
            for item in newItems {
                addItem(item, canShowSeparator: true)
            }
        }
    }
    fileprivate var viewControllers = [UIViewController]()
    
    open override func loadView() {
        view = stackViewContainer
    }
    
    /**
     Adds an item to the list of items managed by the controller. The item can
     be either a `UIView` or a `UIViewController`, both of which conform to the
     `StackViewItem` protocol.
     
     - parameter item:             The item to add
     - parameter canShowSeparator: See the documentation for
     `StackViewContainer.setCanShowSeparator(:forContentViewAtIndex:)` for more
     details on this parameter.
     */
    open func addItem(_ item: StackViewItem, canShowSeparator: Bool = true) {
        insertItem(item, atIndex: _items.endIndex, canShowSeparator: canShowSeparator)
    }
    
    /**
     Inserts an item into the list of items managed by the controller. The item can
     be either a `UIView` or a `UIViewController`, both of which conform to the
     `StackViewItem` protocol.
     
     - parameter item:             The item to insert
     - parameter index:            The index to insert the item at
     - parameter canShowSeparator: See the documentation for
     `StackViewContainer.setCanShowSeparator(:forContentViewAtIndex:)` for more
     details on this parameter.
     */
    open func insertItem(_ item: StackViewItem, atIndex index: Int, canShowSeparator: Bool = true) {
        precondition(index >= _items.startIndex)
        precondition(index <= _items.endIndex)
        
        _items.insert(item, at: index)
        let viewController = item.toViewController()
        viewControllers.insert(viewController, at: index)
        addChild(viewController)
        stackViewContainer.insertContentView(viewController.view, atIndex: index, canShowSeparator: canShowSeparator)
    }
    
    /**
     Removes an item from the list of items managed by this controller. If `item`
     does not exist in `items`, this method does nothing.
     
     - parameter item: The item to remove.
     */
    open func removeItem(_ item: StackViewItem) {

        guard let index = _items.index(where: { $0 === item }) else { return }
        removeItemAtIndex(index)
    }
    
    /**
     Removes an item from the list of items managed by this controller.
     
     - parameter index: The index of the item to remove
     */
    open func removeItemAtIndex(_ index: Int) {
        _items.remove(at: index)
        let viewController = viewControllers[index]
        viewController.willMove(toParent: nil)
        stackViewContainer.removeContentViewAtIndex(index)
        viewController.removeFromParent()
        viewControllers.remove(at: index)
    }
    
    /**
     Sets whether a separator can be shown for `item`
     
     - parameter canShowSeparator: See the documentation for
     `StackViewContainer.setCanShowSeparator(:forContentViewAtIndex:)` for more
     details on this parameter.
     - parameter item:             The item for which to configure separator
     visibility
     */
    open func setCanShowSeparator(_ canShowSeparator: Bool, forItem item: StackViewItem) {
        guard let index = _items.index(where: { $0 === item }) else { return }
        setCanShowSeparator(canShowSeparator, forItemAtIndex: index)
    }
    
    /**
     Sets whether a separator can be shown for the item at index `index`
     
     - parameter canShowSeparator: See the documentation for
     `StackViewContainer.setCanShowSeparator(:forContentViewAtIndex:)` for more
     details on this parameter.
     - parameter index:            The index of the item to configure separator
     visibility for.
     */
    open func setCanShowSeparator(_ canShowSeparator: Bool, forItemAtIndex index: Int) {
        stackViewContainer.setCanShowSeparator(canShowSeparator, forContentViewAtIndex: index)
    }
}
