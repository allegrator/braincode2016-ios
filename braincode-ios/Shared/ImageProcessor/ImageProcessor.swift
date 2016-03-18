//
//  ImageProcessor.swift
//  braincode-ios
//
//  Created by Kacper Harasim on 18.03.2016.
//  Copyright © 2016 Kacper Harasim. All rights reserved.
//

import UIKit
import RxSwift

protocol ImageProcessor {
    func processImage(image: UIImage) -> UIImage
}

class BraincodeImageProcessor: ImageProcessor {

    func processImage(image: UIImage) -> UIImage {
        return image
    }
}
