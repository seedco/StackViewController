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
    fileprivate struct Constants {
        static let ThumbnailSize = CGSize(width: 96, height: 96)
    }
    
    fileprivate var attachmentView: ImageAttachmentView?
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        let attachmentView = ImageAttachmentView(frame: CGRect.zero)
        attachmentView.attachButton.addTarget(self, action: #selector(ImageAttachmentViewController.attachImage(_:)), for: .touchUpInside)
        view = attachmentView
        self.attachmentView = attachmentView
    }
    
    // MARK: Actions
    
    @objc fileprivate func attachImage(_ sender: UIButton) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        guard let imageURL = info[UIImagePickerControllerReferenceURL] as? URL else { return }
        getImageThumbnail(imageURL) { image in
            if let image = image {
                self.attachmentView?.addImageWithThumbnail(image)
            }
        }
    }
    
    fileprivate func getImageThumbnail(_ imageURL: URL, completion: @escaping (UIImage?) -> Void) {
        let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
        guard let asset = result.firstObject else {
            completion(nil)
            return
        }
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.resizeMode = .exact
        options.deliveryMode = .highQualityFormat
        
        let scale = UIScreen.main.scale
        let targetSize: CGSize = {
            var targetSize = Constants.ThumbnailSize
            targetSize.width *= scale
            targetSize.height *= scale
            return targetSize
        }()
        
        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { (image, info) in
            let degraded = info?[PHImageResultIsDegradedKey] as? Bool
            if degraded == nil || degraded! == false {
                if let image = image, let CGImage = image.cgImage {
                    let scaleCorrectedImage = UIImage(cgImage: CGImage, scale: scale, orientation: image.imageOrientation)
                    completion(scaleCorrectedImage)
                } else {
                    completion(nil)
                }
            }
        }
    }
}
