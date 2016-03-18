//
//  ViewController.swift
//  braincode-ios
//
//  Created by Kacper Harasim on 18.03.2016.
//  Copyright © 2016 Kacper Harasim. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    var disposeBag = DisposeBag()
    private var handlerController: ImageHandlerController!
    override func viewDidLoad() {
        super.viewDidLoad()
        handlerController = ImageHandlerController(vc: self)

    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        
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

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {

    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {

    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {

    }


}

