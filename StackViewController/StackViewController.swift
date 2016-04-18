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
public class StackViewController: UIViewController {
    /// This is exposed for configuring `backgroundView`, `stackView`
    /// `axis`, and `separatorViewFactory`. All other operations should
    /// be performed via this controller and not directly via the container view.
    public lazy var stackViewContainer = StackViewContainer()
    
    private var _items = [StackViewItem]()
    
    /// The items displayed by this controller
    public var items: [StackViewItem] {
        get { return _items }
        set(newItems) {
            for (index, _) in _items.enumerate() {
                removeItemAtIndex(index)
            }
            _items = newItems
            for item in newItems {
                addItem(item, canShowSeparator: true)
            }
        }
    }
    private var viewControllers = [UIViewController]()
    
    public override func loadView() {
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
    public func addItem(item: StackViewItem, canShowSeparator: Bool) {
        insertItem(view, atIndex: items.endIndex, canShowSeparator: canShowSeparator)
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
    public func insertItem(item: StackViewItem, atIndex index: Int, canShowSeparator: Bool = true) {
        precondition(index >= items.startIndex)
        precondition(index <= items.endIndex)
        
        items.insert(item, atIndex: index)
        let viewController = item.toViewController()
        viewControllers.insert(viewController, atIndex: index)
        addChildViewController(viewController)
        stackViewContainer.insertContentView(viewController.view, atIndex: index, canShowSeparator: canShowSeparator)
    }
    
    /**
     Removes an item from the list of items managed by this controller. If `item`
     does not exist in `items`, this method does nothing.
     
     - parameter item: The item to remove.
     */
    public func removeItem(item: StackViewItem) {
        guard let index = items.indexOf({ $0 === item }) else { return }
        removeItemAtIndex(index)
    }
    
    /**
     Removes an item from the list of items managed by this controller.
     
     - parameter index: The index of the item to remove
     */
    public func removeItemAtIndex(index: Int) {
        items.removeAtIndex(index)
        let viewController = viewControllers[index]
        viewController.willMoveToParentViewController(nil)
        stackViewContainer.removeContentViewAtIndex(index)
        viewController.removeFromParentViewController()
        viewControllers.removeAtIndex(index)
    }
    
    /**
     Sets whether a separator can be shown for `item`
     
     - parameter canShowSeparator: See the documentation for
     `StackViewContainer.setCanShowSeparator(:forContentViewAtIndex:)` for more
     details on this parameter.
     - parameter item:             The item for which to configure separator
     visibility
     */
    public func setCanShowSeparator(canShowSeparator: Bool, forItem item: StackViewItem) {
        guard let index = items.indexOf({ $0 === item }) else { return }
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
    public func setCanShowSeparator(canShowSeparator: Bool, forItemAtIndex index: Int) {
        stackViewContainer.setCanShowSeparator(canShowSeparator, forContentViewAtIndex: index)
    }
}
