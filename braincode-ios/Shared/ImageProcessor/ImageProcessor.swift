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

    let resizingValue = CGSize(width: 800, height: 800)
    func processImage(image: UIImage) -> UIImage {
        return self.resizeImage(image, toSize: self.resizingValue)
    }

    private func resizeImage(image: UIImage, toSize newSize: CGSize) -> UIImage {

        UIGraphicsBeginImageContext(newSize)
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage

    }
}
