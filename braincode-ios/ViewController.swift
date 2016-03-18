//
//  ViewController.swift
//  braincode-ios
//
//  Created by Kacper Harasim on 18.03.2016.
//  Copyright © 2016 Kacper Harasim. All rights reserved.
//

import UIKit
import RxSwift
import SwiftyJSON

class ViewController: UIViewController {

    private var disposeBag = DisposeBag()
    private let manager: NetworkManager = NetworkManager()
    private var handlerController: ImageHandlerController!
    private var senderController: ImageSenderController!

    override func viewDidLoad() {
        super.viewDidLoad()
        handlerController = ImageHandlerController(vc: self, processor: BraincodeImageProcessor())
        senderController = ImageSenderController(manager: manager)

    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        handlerController.showControllerWithSettings(ImageTakingSettings())
            .subscribe(onNext: { image in
                self.processImageTaken(image)
                }, onError: { error in
                    print("Error has occured: \(error)")
                }, onCompleted: {
                    print("completed")
            }).addDisposableTo(disposeBag)
        
    }

    func processImageTaken(image: UIImage) {
        senderController.uploadImage(image)
            .subscribe(onNext: { elements in
                print(elements)
                },

                onError: { error in
                    print(error)
                }, onCompleted: {
                    print("req completed")
            }).addDisposableTo(disposeBag)
    }


    func performBasicRequest() {
        NetworkManager().basicRequest(.Compute)
            .subscribe(onNext: {
                print($0)
                }, onError: { error in
                    print("Error: \(error)")
                }, onCompleted: {
                    print("completed")

            }).addDisposableTo(disposeBag)
    }

}

