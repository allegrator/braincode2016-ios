//
//  ImageHandlerController.swift
//  braincode-ios
//
//  Created by Kacper Harasim on 18.03.2016.
//  Copyright © 2016 Kacper Harasim. All rights reserved.
//

import UIKit
import RxSwift
import pop
import M13ProgressSuite
import RxCocoa
import SafariServices

struct ImageTakingSettings {

}

enum ImageHandlerError: ErrorType, CustomStringConvertible {

    case OperationCanceled
    case NoImage
    case WrongImage
    var description: String {
        return ""
    }
}
//Code not so pretty here ; (((

@objc class ImageHandlerController: NSObject,  UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    private let imageProcessor: ImageProcessor
    private let subject: PublishSubject<UIImage>
    private let viewControllerToPresentOn: UIViewController
    private let disposeBag = DisposeBag()
    private var visibleProgress: M13ProgressViewPie?
    var imagePickerController: UIImagePickerController?

    var overlayView = UIView()
    init(vc: UIViewController, processor: ImageProcessor) {
        self.subject = PublishSubject()
        self.viewControllerToPresentOn = vc
        self.imageProcessor = processor
    }


    func updateProgress(percentage: Double) {
        guard let controller = imagePickerController else { return }
        dispatch_async(dispatch_get_main_queue()) {
            self.visibleProgress?.alpha = 1.0
            if self.visibleProgress == nil{
               self.visibleProgress = M13ProgressViewPie(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 70.0, height: 70.0)))
                self.visibleProgress?.tintColor = UIColor(red:0.23, green:0.60, blue:0.85, alpha:1.00)
               self.visibleProgress?.center.x = controller.view.center.x
                self.visibleProgress?.frame.origin.y = controller.view.frame.size.height - 70.0
                    controller.cameraOverlayView?.addSubview(self.visibleProgress!)
            }
            self.visibleProgress?.setProgress(CGFloat(percentage), animated: true)
            if percentage == 1.0 {
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.4 * Double(NSEC_PER_SEC)))
                dispatch_after(delayTime, dispatch_get_main_queue()) {
                    self.visibleProgress?.performAction(M13ProgressViewActionSuccess, animated: true)
                    UIView.animateWithDuration(0.4, delay: 0.7, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                            self.visibleProgress?.alpha = 0.0
                        }, completion: { completed in
                            self.visibleProgress?.removeFromSuperview()
                            self.visibleProgress = nil

                    })
                }
            }
        }
    }
    var hintView: UIView?
    var currentElement: ImageRecognizedElementInfo?
    func showOverlay(element: ImageRecognizedElementInfo) {

        currentElement = element
        guard let controller = imagePickerController else { return }
        let height: CGFloat = 92.0
        let controllerView = controller.view
        let view = UIView(frame: CGRectMake(00.0, 0.0, controllerView.frame.width, height))
        self.hintView = view
        if let category = element.categoryId {
            view.backgroundColor = UIColor(red:0.18, green:0.65, blue:0.37, alpha:1.00)
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapOnOverlay:"))
        } else {
            view.backgroundColor = UIColor(red:0.23, green:0.60, blue:0.85, alpha:1.00)
        }
        view.alpha = 1.0
        view.frame.origin.y -= height
        controller.cameraOverlayView?.addSubview(view)

        let label = UILabel(frame: view.bounds)
        label.textColor = UIColor.whiteColor()
        label.text = element.name
        label.textAlignment = .Center
        label.numberOfLines = 0
        view.addSubview(label)

        let popAnimation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
        popAnimation.toValue = NSValue(CGRect:view.frame.translateBy(0, CGFloat(height)))
        popAnimation.springSpeed = 8.0
        popAnimation.springBounciness = 13.0

        view.pop_addAnimation(popAnimation, forKey: "animationA")

    }
    func tapOnOverlay(tapGestureRecognizer: UITapGestureRecognizer) {
        guard let elem = currentElement, catId = elem.categoryId   else { return }
        let string = "http://www.allegro.pl/gunwo-\(elem.categoryId!)"
        let svc = SFSafariViewController(URL: NSURL(string: string)!)
        imagePickerController?.presentViewController(svc, animated: true, completion: nil)

    }
    func showControllerWithSettings(settings: ImageTakingSettings) -> Observable<UIImage> {

        let imagePicker =  UIImagePickerController()
        imagePicker.delegate = self

        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        imagePicker.showsCameraControls = false
        viewControllerToPresentOn.presentViewController(imagePicker, animated: true, completion: nil)
        self.imagePickerController = imagePicker
        overlayView.frame = imagePicker.view.bounds
        overlayView.userInteractionEnabled = true


        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        button.center.x = overlayView.center.x
        button.frame.origin.y = overlayView.frame.height - 140.0
        button.setTitle("Take photo", forState: .Normal)
        button.userInteractionEnabled = false
        overlayView.addSubview(button)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapOnView:")
        overlayView.addGestureRecognizer(tapGestureRecognizer)

        imagePicker.cameraOverlayView = overlayView

        return subject
    }
    func tapOnView(gestureRecognizer: UITapGestureRecognizer) {
        takePicture()

    }
    func takePicture() {
        if let view = hintView {
            let popAnimation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
            popAnimation.toValue = NSValue(CGRect:view.frame.translateBy(0, -CGFloat(view.frame.height)))
            popAnimation.springSpeed = 18.0
            popAnimation.springBounciness = 1
            view.pop_addAnimation(popAnimation, forKey: "animationA")
            popAnimation.completionBlock = { _, _ in
                self.hintView?.removeFromSuperview()
                return
            }
        }
        imagePickerController?.takePicture()

    }
    private let tappedInfoSubject = PublishSubject<ImageRecognizedElementInfo>()

    func tapInfo() -> Observable<ImageRecognizedElementInfo> {
        return tappedInfoSubject
    }
    

    @objc func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {

        let originalImg:UIImage? = info[UIImagePickerControllerOriginalImage] as? UIImage
        if let image = originalImg {
            let processed = imageProcessor.processImage(image)
            subject.onNext(processed)
        } else {
            subject.onError(ImageHandlerError.NoImage)
        }
    }

    @objc func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        subject.onError(ImageHandlerError.OperationCanceled)
    }

}