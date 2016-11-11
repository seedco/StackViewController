//
//  ImageAttachmentView.swift
//  StackViewController
//
//  Created by Indragie Karunaratne on 2016-04-24.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit
import StackViewController

class ImageAttachmentView: UIView, ImageThumbnailViewDelegate {
    fileprivate struct Layout {
        static let ContainerInsets = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        static let ScrollViewInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        static let StackViewSpacing: CGFloat = 10
    }
    
    let attachButton: UIButton
    fileprivate let stackViewContainer: StackViewContainer
    
    override init(frame: CGRect) {
        attachButton = UIButton(type: .custom)
        attachButton.setBackgroundImage(UIImage(named: "attach-button")!, for: UIControlState())
        attachButton.adjustsImageWhenHighlighted = true
        
        let stackView = UIStackView(frame: CGRect.zero)
        stackView.axis = .horizontal
        stackView.alignment = .bottom
        
        stackViewContainer = StackViewContainer(stackView: stackView)
        stackViewContainer.addContentView(attachButton)
        
        super.init(frame: frame)
        
        let scrollView = stackViewContainer.scrollView
        scrollView.alwaysBounceHorizontal = true
        scrollView.contentInset = Layout.ScrollViewInsets
        scrollView.scrollIndicatorInsets = Layout.ScrollViewInsets
        
        addSubview(stackViewContainer)
        _ = stackViewContainer.activateSuperviewHuggingConstraints(insets: Layout.ContainerInsets)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addImageWithThumbnail(_ thumbnail: UIImage) {
        let thumbnailView = ImageThumbnailView(thumbnail: thumbnail)
        thumbnailView.delegate = self
        stackViewContainer.addContentView(thumbnailView)
    }
    
    // MARK: ImageThumbnailViewDelegate
    
    func imageThumbnailViewDidTapDeleteButton(_ view: ImageThumbnailView) {
        stackViewContainer.removeContentView(view)
    }
}
