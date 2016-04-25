//
//  ImageAttachmentViewController.swift
//  StackViewController
//
//  Created by Indragie Karunaratne on 2016-04-24.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit

class ImageAttachmentViewController: UIViewController {
    private var attachmentView: ImageAttachmentView?
    
    override func loadView() {
        let attachmentView = ImageAttachmentView(frame: CGRectZero)
        attachmentView.attachButton.addTarget(self, action: #selector(ImageAttachmentViewController.attachImage(_:)), forControlEvents: .TouchUpInside)
        view = attachmentView
        self.attachmentView = attachmentView
    }
    
    // MARK: Actions
    
    @objc private func attachImage(sender: UIButton) {
        print("Attach an image")
    }
}
