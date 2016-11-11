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
    /// This is exposed for configuring `backgroundView`, `stackView`
    /// `axis`, and `separatorViewFactory`. All other operations should
    /// be performed via this controller and not directly via the container view.
    open lazy var stackViewContainer = StackViewContainer()
    
    fileprivate var _items = [StackViewItem]()
    
    /// The items displayed by this controller
    open var items: [StackViewItem] {
        get { return _items }
        set(newItems) {
            for (index, _) in _items.enumerated() {
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
        addChildViewController(viewController)
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
        viewController.willMove(toParentViewController: nil)
        stackViewContainer.removeContentViewAtIndex(index)
        viewController.removeFromParentViewController()
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
