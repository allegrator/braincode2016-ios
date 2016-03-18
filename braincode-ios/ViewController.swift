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

    var disposeBag = DisposeBag()
    private var handlerController: ImageHandlerController!
    override func viewDidLoad() {
        super.viewDidLoad()
        handlerController = ImageHandlerController(vc: self, processor: BraincodeImageProcessor())

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

    func processImageTaken(image: UIImage) -> Observable<JSON> {
        return Observable.empty()
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

