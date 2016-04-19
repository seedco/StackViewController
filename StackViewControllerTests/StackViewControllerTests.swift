//
//  StackViewControllerTests.swift
//  StackViewControllerTests
//
//  Created by Indragie Karunaratne on 2016-04-16.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import XCTest
@testable import StackViewController

class StackViewControllerTests: XCTestCase {
    private var stackViewController: StackViewController!
    
    private class TestViewController: UIViewController {
        convenience init() {
            self.init(nibName: nil, bundle: nil)
        }
        
        private override func loadView() {
            view = UIView(frame: CGRectZero)
            view.tag = 1000
        }
    }
    
    override func setUp() {
        super.setUp()
        stackViewController = StackViewController()
    }
    
    private func createViewWithTag(tag: Int) -> UIView {
        let view = UIView(frame: CGRectZero)
        view.tag = tag
        return view
    }
    
    func testAddView() {
        stackViewController.addItem(createViewWithTag(1))
        
        XCTAssertEqual(1, stackViewController.items[0].tag)
        XCTAssertEqual(1, stackViewController.childViewControllers.count)
    }
    
    func testAddViewController() {
        let viewController = TestViewController()
        stackViewController.addItem(viewController)
        
        XCTAssertEqual(1000, stackViewController.items[0].tag)
        XCTAssertEqual(1, stackViewController.childViewControllers.count)
        XCTAssertEqual(viewController, stackViewController.childViewControllers[0])
    }
    
    func testInsertView() {
        stackViewController.addItem(TestViewController())
        stackViewController.addItem(TestViewController())
        stackViewController.insertItem(createViewWithTag(1), atIndex: 1)
        
        XCTAssertEqual([1000, 1, 1000], stackViewController.items.map { $0.tag })
        XCTAssertEqual(3, stackViewController.childViewControllers.count)
    }
    
    func testInsertViewController() {
        stackViewController.addItem(createViewWithTag(1))
        stackViewController.addItem(createViewWithTag(2))
        stackViewController.insertItem(TestViewController(), atIndex: 1)
        
        XCTAssertEqual([1, 1000, 2], stackViewController.items.map { $0.tag })
        XCTAssertEqual(3, stackViewController.childViewControllers.count)
    }
    
    func testRemoveViewAtIndex() {
        stackViewController.addItem(createViewWithTag(1))
        stackViewController.addItem(TestViewController())
        stackViewController.removeItemAtIndex(0)
        
        XCTAssertEqual([1000], stackViewController.items.map { $0.tag })
        XCTAssertEqual(1, stackViewController.childViewControllers.count)
    }
    
    func testRemoveViewControllerAtIndex() {
        stackViewController.addItem(createViewWithTag(1))
        stackViewController.addItem(TestViewController())
        stackViewController.removeItemAtIndex(1)
        
        XCTAssertEqual([1], stackViewController.items.map { $0.tag })
        XCTAssertEqual(1, stackViewController.childViewControllers.count)
    }
    
    func testRemoveItemWithExistingItem() {
        stackViewController.addItem(createViewWithTag(1))
        let viewController = TestViewController()
        stackViewController.addItem(viewController)
        stackViewController.removeItem(viewController)
        
        XCTAssertEqual([1], stackViewController.items.map { $0.tag })
        XCTAssertEqual(1, stackViewController.childViewControllers.count)
    }
    
    func testRemoveItemWithNonexistentItem() {
        stackViewController.addItem(createViewWithTag(1))
        stackViewController.addItem(TestViewController())
        stackViewController.removeItem(TestViewController())
        
        XCTAssertEqual([1, 1000], stackViewController.items.map { $0.tag })
        XCTAssertEqual(2, stackViewController.childViewControllers.count)
    }
}

private extension StackViewItem {
    var tag: Int {
        if let view = self as? UIView {
            return view.tag
        } else if let viewController = self as? UIViewController {
            return viewController.view.tag
        } else {
            return -1
        }
    }
}
