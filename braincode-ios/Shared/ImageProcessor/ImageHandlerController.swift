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
    var description: String {
        return ""
    }
}


@objc class ImageHandlerController: NSObject,  UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    private let subject: PublishSubject<UIImage>
    private let viewControllerToPresentOn: UIViewController

    init(vc: UIViewController) {
        self.subject = PublishSubject()
        self.viewControllerToPresentOn = vc
    }

    func showControllerWithSettings(settings: ImageTakingSettings) -> Observable<UIImage> {

        let imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        viewControllerToPresentOn.presentViewController(imagePicker, animated: true, completion: nil)

        return subject
    }
    

    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {

    }
    @objc func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
//        let savePath:String = sedocumentsPath()! + "/" + self.presentDateTimeString() + ".png"
//        // try to get our edited image if there is one, as well as the original image
//        let editedImg:UIImage?   = info[UIImagePickerControllerEditedImage] as? UIImage
//        let originalImg:UIImage? = info[UIImagePickerControllerOriginalImage] as? UIImage
//
//        // create our image data with the edited img if we have one, else use the original image
//        let imgData:NSData = editedImg == nil ? UIImagePNGRepresentation(editedImg!)! : UIImagePNGRepresentation(originalImg!)!
//
//        // write the image data to file
//        imgData.writeToFile(savePath, atomically: true)
//
//        // dismiss the picker
//        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @objc func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        subject.onError(ImageHandlerError.OperationCanceled)
    }

}