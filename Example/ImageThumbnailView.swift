//
//  ImageThumbnailView.swift
//  StackViewController
//
//  Created by Indragie Karunaratne on 2016-04-24.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit
import StackViewController

public class ImageThumbnailView: UIView {
    private struct Appearance {
        static let ImageCornerRadius: CGFloat = 8.0
    }
    
    let deleteButton: UIButton
    
    init(thumbnail: UIImage) {
        let deleteButtonImage = UIImage(named: "delete-button")!
        deleteButton = UIButton(type: .Custom)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.setBackgroundImage(deleteButtonImage, forState: .Normal)
        
        super.init(frame: CGRectZero)
        
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
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[deleteButton]-imageViewTop-[imageView]|", options: [], metrics: metrics, views: views)
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[deleteButton]-imageViewLeft-[imageView]|", options: [], metrics: metrics, views: views)
        NSLayoutConstraint.activateConstraints(verticalConstraints)
        NSLayoutConstraint.activateConstraints(horizontalConstraints)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
