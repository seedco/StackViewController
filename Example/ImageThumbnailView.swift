//
//  ImageThumbnailView.swift
//  StackViewController
//
//  Created by Indragie Karunaratne on 2016-04-24.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit
import StackViewController

protocol ImageThumbnailViewDelegate: AnyObject {
    func imageThumbnailViewDidTapDeleteButton(_ view: ImageThumbnailView)
}

open class ImageThumbnailView: UIView {
    fileprivate struct Appearance {
        static let ImageCornerRadius: CGFloat = 8.0
    }
    
    weak var delegate: ImageThumbnailViewDelegate?
    
    init(thumbnail: UIImage) {
        super.init(frame: CGRect.zero)
        
        let deleteButtonImage = UIImage(named: "delete-button")!
        let deleteButton = UIButton(type: .custom)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.setBackgroundImage(deleteButtonImage, for: UIControlState())
        deleteButton.addTarget(self, action: #selector(ImageThumbnailView.didTapDelete(_:)), for: .touchUpInside)
        
        let imageView = UIImageView(image: thumbnail)
        imageView.layer.cornerRadius = Appearance.ImageCornerRadius
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(imageView)
        addSubview(deleteButton)
        
        let metrics = [
            "imageViewLeft": -(deleteButtonImage.size.width / 2),
            "imageViewTop": -(deleteButtonImage.size.height / 2)
        ]
        let views = [
            "deleteButton": deleteButton,
            "imageView": imageView
        ]
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[deleteButton]-imageViewTop-[imageView]|", options: [], metrics: metrics, views: views)
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[deleteButton]-imageViewLeft-[imageView]|", options: [], metrics: metrics, views: views)
        NSLayoutConstraint.activate(verticalConstraints)
        NSLayoutConstraint.activate(horizontalConstraints)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    
    @objc fileprivate func didTapDelete(_ sender: UIButton) {
        delegate?.imageThumbnailViewDidTapDeleteButton(self)
    }
}
