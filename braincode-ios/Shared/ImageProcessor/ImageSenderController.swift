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

    func uploadImage(image: UIImage) -> Observable<[ImageRecognizedElementInfo]> {
        if let representation = UIImageJPEGRepresentation(image, 0.9) {
            return networkManager.sendDataMultipart(representation).flatMap {
                json -> Observable<[ImageRecognizedElementInfo]> in
                guard let array = json.array else { return Observable.error(NetworkManagerError.JSONParsingError) }
                let mapped = array.flatMap {  ImageRecognizedElementInfo(json: $0) }
                return Observable.just(mapped)

            }
        }
        return Observable.error(ImageHandlerError.WrongImage)
    }
}