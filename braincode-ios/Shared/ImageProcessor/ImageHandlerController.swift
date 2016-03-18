//
//  ImageHandlerController.swift
//  braincode-ios
//
//  Created by Kacper Harasim on 18.03.2016.
//  Copyright © 2016 Kacper Harasim. All rights reserved.
//

import UIKit
import RxSwift


struct ImageTakingSettings {

}

enum ImageHandlerError: ErrorType, CustomStringConvertible {

    case OperationCanceled
    case NoImage
    var description: String {
        return ""
    }
}


@objc class ImageHandlerController: NSObject,  UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    private let imageProcessor: ImageProcessor
    private let subject: PublishSubject<UIImage>
    private let viewControllerToPresentOn: UIViewController

    init(vc: UIViewController, processor: ImageProcessor) {
        self.subject = PublishSubject()
        self.viewControllerToPresentOn = vc
        self.imageProcessor = processor
    }

    func showControllerWithSettings(settings: ImageTakingSettings) -> Observable<UIImage> {

        let imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        viewControllerToPresentOn.presentViewController(imagePicker, animated: true, completion: nil)

        return subject
    }
    

    @objc func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {

        let originalImg:UIImage? = info[UIImagePickerControllerOriginalImage] as? UIImage
        if let image = originalImg {
            let processed = imageProcessor.processImage(image)
            subject.onNext(processed)
            subject.onCompleted()
        } else {
            subject.onError(ImageHandlerError.NoImage)
        }
    }

    @objc func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        subject.onError(ImageHandlerError.OperationCanceled)
    }

}