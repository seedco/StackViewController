//
//  ImageAttachmentViewController.swift
//  StackViewController
//
//  Created by Indragie Karunaratne on 2016-04-24.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit
import Photos

class ImageAttachmentViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private struct Constants {
        static let ThumbnailSize = CGSize(width: 96, height: 96)
    }
    
    private var attachmentView: ImageAttachmentView?
    
    override func loadView() {
        let attachmentView = ImageAttachmentView(frame: CGRectZero)
        attachmentView.attachButton.addTarget(self, action: #selector(ImageAttachmentViewController.attachImage(_:)), forControlEvents: .TouchUpInside)
        view = attachmentView
        self.attachmentView = attachmentView
    }
    
    // MARK: Actions
    
    @objc private func attachImage(sender: UIButton) {
        guard UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) else { return }
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .PhotoLibrary
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        guard let imageURL = info[UIImagePickerControllerReferenceURL] as? NSURL else { return }
        getImageThumbnail(imageURL) { image in
            if let image = image {
                self.attachmentView?.addImageWithThumbnail(image)
            }
        }
    }
    
    private func getImageThumbnail(imageURL: NSURL, completion: UIImage? -> Void) {
        let result = PHAsset.fetchAssetsWithALAssetURLs([imageURL], options: nil)
        guard let asset = result.firstObject as? PHAsset else {
            completion(nil)
            return
        }
        let imageManager = PHImageManager.defaultManager()
        let options = PHImageRequestOptions()
        options.resizeMode = .Exact
        options.deliveryMode = .HighQualityFormat
        
        let scale = UIScreen.mainScreen().scale
        let targetSize: CGSize = {
            var targetSize = Constants.ThumbnailSize
            targetSize.width *= scale
            targetSize.height *= scale
            return targetSize
        }()
        
        imageManager.requestImageForAsset(asset, targetSize: targetSize, contentMode: .AspectFill, options: options) { (image, info) in
            let degraded = info?[PHImageResultIsDegradedKey] as? Bool
            if degraded == nil || degraded! == false {
                if let image = image, CGImage = image.CGImage {
                    let scaleCorrectedImage = UIImage(CGImage: CGImage, scale: scale, orientation: image.imageOrientation)
                    completion(scaleCorrectedImage)
                } else {
                    completion(nil)
                }
            }
        }
    }
}
