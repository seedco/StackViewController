//
//  StackViewContainerTests.swift
//  StackViewController
//
//  Created by Indragie Karunaratne on 2016-04-16.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import XCTest
@testable import StackViewController

class StackViewContainerTests: XCTestCase {
    fileprivate final class ContentView: UIView {}
    
    fileprivate var stackViewContainer: StackViewContainer!

    override func setUp() {
        super.setUp()
        stackViewContainer = StackViewContainer()
        stackViewContainer.separatorViewFactory = StackViewContainer.createSeparatorViewFactory()
    }
    
    fileprivate func contentViewWithTag(_ tag: Int) -> ContentView {
        let contentView = ContentView()
        contentView.tag = tag
        return contentView
    }
    
    func testStackInitiallyEmpty() {
        XCTAssertEqual(0, stackViewContainer.stackView.arrangedSubviews.count)
        XCTAssertEqual(0, stackViewContainer.contentViews.count)
    }
    
    func testAddContentViewWithoutSeparator() {
        stackViewContainer.addContentView(contentViewWithTag(1), canShowSeparator: false)
        stackViewContainer.addContentView(contentViewWithTag(2), canShowSeparator: true)
        
        XCTAssertEqual(2, stackViewContainer.stackView.arrangedSubviews.count)
        XCTAssertEqual([1, 2], stackViewContainer.contentViews.map { $0.tag })
    }

    func testAddContentViewWithSeparator() {
        stackViewContainer.addContentView(contentViewWithTag(1), canShowSeparator: true)
        stackViewContainer.addContentView(contentViewWithTag(2), canShowSeparator: true)
        
        XCTAssertEqual(2, stackViewContainer.contentViews.count)
        XCTAssertEqual([1, 0, 2], stackViewContainer.stackView.arrangedSubviews.map { $0.tag })
    }
    
    func testInsertContentViewAtLastExistingIndexWithSeparator() {
        stackViewContainer.addContentView(contentViewWithTag(1), canShowSeparator: true)
        stackViewContainer.addContentView(contentViewWithTag(2), canShowSeparator: true)
        stackViewContainer.insertContentView(contentViewWithTag(3), atIndex: 1, canShowSeparator: true)
        
        XCTAssertEqual(3, stackViewContainer.contentViews.count)
        XCTAssertEqual([1, 0, 3, 0, 2], stackViewContainer.stackView.arrangedSubviews.map { $0.tag })
    }
    
    func testInsertContentViewAtLastExistingIndexWithoutSeparator() {
        stackViewContainer.addContentView(contentViewWithTag(1), canShowSeparator: true)
        stackViewContainer.addContentView(contentViewWithTag(2), canShowSeparator: true)
        stackViewContainer.insertContentView(contentViewWithTag(3), atIndex: 1, canShowSeparator: false)
        
        XCTAssertEqual(3, stackViewContainer.contentViews.count)
        XCTAssertEqual([1, 0, 3, 2], stackViewContainer.stackView.arrangedSubviews.map { $0.tag })
    }
    
    func testInsertContentViewAtEndIndexWithSeparator() {
        stackViewContainer.addContentView(contentViewWithTag(1), canShowSeparator: true)
        stackViewContainer.insertContentView(contentViewWithTag(2), atIndex: 1, canShowSeparator: true)
        
        XCTAssertEqual(2, stackViewContainer.contentViews.count)
        XCTAssertEqual([1, 0, 2], stackViewContainer.stackView.arrangedSubviews.map { $0.tag })
    }
    
    func testInsertContentViewAtEndIndexWithoutSeparator() {
        stackViewContainer.addContentView(contentViewWithTag(1), canShowSeparator: true)
        stackViewContainer.insertContentView(contentViewWithTag(2), atIndex: 1, canShowSeparator: false)
        
        XCTAssertEqual(2, stackViewContainer.contentViews.count)
        XCTAssertEqual([1, 0, 2], stackViewContainer.stackView.arrangedSubviews.map { $0.tag })
    }
    
    func testInsertContentViewAtIndexWithSeparator() {
        stackViewContainer.addContentView(contentViewWithTag(1), canShowSeparator: true)
        stackViewContainer.addContentView(contentViewWithTag(2), canShowSeparator: true)
        stackViewContainer.addContentView(contentViewWithTag(3), canShowSeparator: true)
        stackViewContainer.addContentView(contentViewWithTag(4), canShowSeparator: true)
        
        stackViewContainer.insertContentView(contentViewWithTag(5), atIndex: 2, canShowSeparator: true)
        
        XCTAssertEqual(5, stackViewContainer.contentViews.count)
        XCTAssertEqual([1, 0, 2, 0, 5, 0, 3, 0, 4], stackViewContainer.stackView.arrangedSubviews.map { $0.tag })
    }
    
    func testInsertContentViewAtIndexWithoutSeparator() {
        stackViewContainer.addContentView(contentViewWithTag(1), canShowSeparator: true)
        stackViewContainer.addContentView(contentViewWithTag(2), canShowSeparator: true)
        stackViewContainer.addContentView(contentViewWithTag(3), canShowSeparator: true)
        stackViewContainer.addContentView(contentViewWithTag(4), canShowSeparator: true)
        
        stackViewContainer.insertContentView(contentViewWithTag(5), atIndex: 2, canShowSeparator: false)

        XCTAssertEqual(5, stackViewContainer.contentViews.count)
        XCTAssertEqual([1, 0, 2, 0, 5, 3, 0, 4], stackViewContainer.stackView.arrangedSubviews.map { $0.tag })
    }
    
    func testRemoveContentViewAtLastExistingIndexWithSeparator() {
        stackViewContainer.addContentView(contentViewWithTag(1), canShowSeparator: true)
        stackViewContainer.addContentView(contentViewWithTag(2), canShowSeparator: true)
        
        stackViewContainer.removeContentViewAtIndex(1)
        
        XCTAssertEqual(1, stackViewContainer.contentViews.count)
        XCTAssertEqual([1], stackViewContainer.stackView.arrangedSubviews.map { $0.tag })
    }
    
    func testRemoveContentViewAtLastExistingIndexWithoutSeparator() {
        stackViewContainer.addContentView(contentViewWithTag(1), canShowSeparator: true)
        stackViewContainer.addContentView(contentViewWithTag(2), canShowSeparator: false)
        
        stackViewContainer.removeContentViewAtIndex(1)
        
        XCTAssertEqual(1, stackViewContainer.contentViews.count)
        XCTAssertEqual([1], stackViewContainer.stackView.arrangedSubviews.map { $0.tag })
    }
    
    func testRemoveContentViewAtIndexWithSeparator() {
        stackViewContainer.addContentView(contentViewWithTag(1), canShowSeparator: true)
        stackViewContainer.addContentView(contentViewWithTag(2), canShowSeparator: true)
        stackViewContainer.addContentView(contentViewWithTag(3), canShowSeparator: true)
        
        stackViewContainer.removeContentViewAtIndex(0)
        
        XCTAssertEqual(2, stackViewContainer.contentViews.count)
        XCTAssertEqual([2, 0, 3], stackViewContainer.stackView.arrangedSubviews.map { $0.tag })
    }
    
    func testRemoveContentViewAtIndexWithoutSeparator() {
        stackViewContainer.addContentView(contentViewWithTag(1), canShowSeparator: false)
        stackViewContainer.addContentView(contentViewWithTag(2), canShowSeparator: true)
        stackViewContainer.addContentView(contentViewWithTag(3), canShowSeparator: true)
        
        stackViewContainer.removeContentViewAtIndex(0)
        
        XCTAssertEqual(2, stackViewContainer.contentViews.count)
        XCTAssertEqual([2, 0, 3], stackViewContainer.stackView.arrangedSubviews.map { $0.tag })
    }
    
    func testRemoveContentViewWithExistingView() {
        let contentView = contentViewWithTag(1)
        stackViewContainer.addContentView(contentView, canShowSeparator: true)
        stackViewContainer.addContentView(contentViewWithTag(2), canShowSeparator: true)
        stackViewContainer.addContentView(contentViewWithTag(3), canShowSeparator: true)
        
        stackViewContainer.removeContentView(contentView)
        
        XCTAssertEqual(2, stackViewContainer.contentViews.count)
        XCTAssertEqual([2, 0, 3], stackViewContainer.stackView.arrangedSubviews.map { $0.tag })
    }
    
    func testRemoveContentViewWithNonexistentView() {
        stackViewContainer.addContentView(contentViewWithTag(1), canShowSeparator: true)
        stackViewContainer.addContentView(contentViewWithTag(2), canShowSeparator: true)
        stackViewContainer.addContentView(contentViewWithTag(3), canShowSeparator: true)
        
        stackViewContainer.removeContentView(contentViewWithTag(3))
        
        XCTAssertEqual(3, stackViewContainer.contentViews.count)
        XCTAssertEqual([1, 0, 2, 0, 3], stackViewContainer.stackView.arrangedSubviews.map { $0.tag })
    }
    
    func testSetCanShowSeparatorTrue() {
        stackViewContainer.addContentView(contentViewWithTag(1), canShowSeparator: false)
        stackViewContainer.addContentView(contentViewWithTag(2), canShowSeparator: true)
        
        stackViewContainer.setCanShowSeparator(true, forContentViewAtIndex: 0)
        
        XCTAssertEqual(2, stackViewContainer.contentViews.count)
        XCTAssertEqual([1, 0, 2], stackViewContainer.stackView.arrangedSubviews.map { $0.tag })
    }
    
    func testSetCanShowSeparatorFalse() {
        stackViewContainer.addContentView(contentViewWithTag(1), canShowSeparator: true)
        stackViewContainer.addContentView(contentViewWithTag(2), canShowSeparator: true)
        
        stackViewContainer.setCanShowSeparator(false, forContentViewAtIndex: 0)
        
        XCTAssertEqual(2, stackViewContainer.contentViews.count)
        XCTAssertEqual([1, 2], stackViewContainer.stackView.arrangedSubviews.map { $0.tag })
    }
    
    func testSetCanShowSeparatorTrueWithLastExistingIndex() {
        stackViewContainer.addContentView(contentViewWithTag(1), canShowSeparator: false)
        
        stackViewContainer.setCanShowSeparator(true, forContentViewAtIndex: 0)
        
        XCTAssertEqual(1, stackViewContainer.contentViews.count)
        XCTAssertEqual([1], stackViewContainer.stackView.arrangedSubviews.map { $0.tag })
    }
    
    func testSetCanShowSeparatorFalseWithLastExistingIndex() {
        stackViewContainer.addContentView(contentViewWithTag(1), canShowSeparator: true)
        
        stackViewContainer.setCanShowSeparator(false, forContentViewAtIndex: 0)
        
        XCTAssertEqual(1, stackViewContainer.contentViews.count)
        XCTAssertEqual([1], stackViewContainer.stackView.arrangedSubviews.map { $0.tag })
    }
    
    func testSetCanShowSeparatorWithExistingView() {
        let contentView = contentViewWithTag(1)
        stackViewContainer.addContentView(contentView, canShowSeparator: false)
        stackViewContainer.addContentView(contentViewWithTag(2), canShowSeparator: true)
        
        stackViewContainer.setCanShowSeparator(true, forContentView: contentView)
        
        XCTAssertEqual(2, stackViewContainer.contentViews.count)
        XCTAssertEqual([1, 0, 2], stackViewContainer.stackView.arrangedSubviews.map { $0.tag })
    }
    
    func testSetCanShowSeparatorWithNonexistentView() {
        stackViewContainer.addContentView(contentViewWithTag(1), canShowSeparator: true)
        stackViewContainer.addContentView(contentViewWithTag(2), canShowSeparator: true)
        
        stackViewContainer.setCanShowSeparator(false, forContentView: contentViewWithTag(1))
        
        XCTAssertEqual(2, stackViewContainer.contentViews.count)
        XCTAssertEqual([1, 0, 2], stackViewContainer.stackView.arrangedSubviews.map { $0.tag })
    }
    
    func testContentViewsSetter() {
        stackViewContainer.contentViews = [
            contentViewWithTag(1),
            contentViewWithTag(2)
        ]
        XCTAssertEqual(2, stackViewContainer.contentViews.count)
        XCTAssertEqual([1, 0, 2], stackViewContainer.stackView.arrangedSubviews.map { $0.tag })
        
        stackViewContainer.contentViews = []
        XCTAssertEqual(0, stackViewContainer.contentViews.count)
        XCTAssertEqual([], stackViewContainer.stackView.arrangedSubviews)
    }
    
    func testSeparatorViewFactorySetter() {
        let separatorViewFactory = stackViewContainer.separatorViewFactory
        stackViewContainer.separatorViewFactory = nil
        stackViewContainer.contentViews = [
            contentViewWithTag(1),
            contentViewWithTag(2)
        ]
        XCTAssertEqual(2, stackViewContainer.contentViews.count)
        XCTAssertEqual([1, 2], stackViewContainer.stackView.arrangedSubviews.map { $0.tag })
        
        stackViewContainer.separatorViewFactory = separatorViewFactory
        XCTAssertEqual(2, stackViewContainer.contentViews.count)
        XCTAssertEqual([1, 0, 2], stackViewContainer.stackView.arrangedSubviews.map { $0.tag })
    }
    
    func testAxisSetter() {
        stackViewContainer.contentViews = [
            contentViewWithTag(1),
            contentViewWithTag(2)
        ]
        
        let assertSeparatorAxes: (UILayoutConstraintAxis) -> Void = { axis in
            let separators: [SeparatorView] = self.stackViewContainer.stackView.arrangedSubviews
                .filter { $0.isKind(of: SeparatorView.self) }
                .map { $0 as! SeparatorView }
            separators.forEach {
                XCTAssertNotEqual(axis, $0.axis)
            }
        }
        
        assertSeparatorAxes(.vertical)
        stackViewContainer.axis = .horizontal
        assertSeparatorAxes(.horizontal)
    }
}
