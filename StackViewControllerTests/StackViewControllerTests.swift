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
    fileprivate var stackViewController: StackViewController!
    
    fileprivate class TestViewController: UIViewController {
        fileprivate let tag: Int
        
        init(tag: Int) {
            self.tag = tag
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        fileprivate override func loadView() {
            view = UIView(frame: CGRect.zero)
            view.tag = tag
        }
    }
    
    override func setUp() {
        super.setUp()
        stackViewController = StackViewController()
    }
    
    fileprivate func createViewWithTag(_ tag: Int) -> UIView {
        let view = UIView(frame: CGRect.zero)
        view.tag = tag
        return view
    }
    
    func testAddView() {
        stackViewController.addItem(createViewWithTag(1))
        
        XCTAssertEqual(1, stackViewController.items[0].tag)
        XCTAssertEqual(1, stackViewController.childViewControllers.count)
    }
    
    func testAddViewController() {
        let viewController = TestViewController(tag: 10)
        stackViewController.addItem(viewController)
        
        XCTAssertEqual(10, stackViewController.items[0].tag)
        XCTAssertEqual(1, stackViewController.childViewControllers.count)
        XCTAssertEqual(viewController, stackViewController.childViewControllers[0])
    }
    
    func testInsertView() {
        stackViewController.addItem(TestViewController(tag: 10))
        stackViewController.addItem(TestViewController(tag: 10))
        stackViewController.insertItem(createViewWithTag(1), atIndex: 1)
        
        XCTAssertEqual([10, 1, 10], stackViewController.items.map { $0.tag })
        XCTAssertEqual(3, stackViewController.childViewControllers.count)
    }
    
    func testInsertViewController() {
        stackViewController.addItem(createViewWithTag(1))
        stackViewController.addItem(createViewWithTag(2))
        stackViewController.insertItem(TestViewController(tag: 10), atIndex: 1)
        
        XCTAssertEqual([1, 10, 2], stackViewController.items.map { $0.tag })
        XCTAssertEqual(3, stackViewController.childViewControllers.count)
    }
    
    func testRemoveViewAtIndex() {
        stackViewController.addItem(createViewWithTag(1))
        stackViewController.addItem(TestViewController(tag: 10))
        stackViewController.removeItemAtIndex(0)
        
        XCTAssertEqual([10], stackViewController.items.map { $0.tag })
        XCTAssertEqual(1, stackViewController.childViewControllers.count)
    }
    
    func testRemoveViewControllerAtIndex() {
        stackViewController.addItem(createViewWithTag(1))
        stackViewController.addItem(TestViewController(tag: 10))
        stackViewController.removeItemAtIndex(1)
        
        XCTAssertEqual([1], stackViewController.items.map { $0.tag })
        XCTAssertEqual(1, stackViewController.childViewControllers.count)
    }
    
    func testRemoveItemWithExistingItem() {
        stackViewController.addItem(createViewWithTag(1))
        let viewController = TestViewController(tag: 10)
        stackViewController.addItem(viewController)
        stackViewController.removeItem(viewController)
        
        XCTAssertEqual([1], stackViewController.items.map { $0.tag })
        XCTAssertEqual(1, stackViewController.childViewControllers.count)
    }
    
    func testRemoveItemWithNonexistentItem() {
        stackViewController.addItem(createViewWithTag(1))
        stackViewController.addItem(TestViewController(tag: 10))
        stackViewController.removeItem(TestViewController(tag: 10))
        
        XCTAssertEqual([1, 10], stackViewController.items.map { $0.tag })
        XCTAssertEqual(2, stackViewController.childViewControllers.count)
    }
    
    func testItemsSetter() {
        stackViewController.items = [
            createViewWithTag(1),
            TestViewController(tag: 10)
        ]
        
        XCTAssertEqual([1, 10], stackViewController.items.map { $0.tag })
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
