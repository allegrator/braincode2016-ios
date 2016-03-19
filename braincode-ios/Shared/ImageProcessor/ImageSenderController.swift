//
//  ImageSenderController.swift
//  braincode-ios
//
//  Created by Kacper Harasim on 18.03.2016.
//  Copyright © 2016 Kacper Harasim. All rights reserved.
//

import Foundation
import RxSwift

class ImageSenderController {

    let networkManager: NetworkManager

    init(manager: NetworkManager) {
        self.networkManager = manager
    }

    func uploadImage(image: UIImage) -> (Observable<ImageRecognizedElementInfo>, Observable<Double>) {
        if let representation = UIImageJPEGRepresentation(image, 0.9 ) {
            let (json, progress) = networkManager.sendDataMultipart(representation)

            let result = json.flatMap {
                json -> Observable<ImageRecognizedElementInfo> in
                if let mapped = ImageRecognizedElementInfo(json: json) {
                    return Observable.just(mapped)
                } else {
                    return Observable.error(NetworkManagerError.JSONParsingError)
                }
            }
            return (result, progress)
        }
        fatalError()
    }
}