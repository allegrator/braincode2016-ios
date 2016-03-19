//
//  ImageRecognizedInfo.swift
//  braincode-ios
//
//  Created by Kacper Harasim on 18.03.2016.
//  Copyright © 2016 Kacper Harasim. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Position {
    let x1: Double
    let x2: Double
    let y1: Double
    let y2: Double
}

struct ImageRecognizedElementInfo {

    let position: Position?
    let name: String
    let categoryId: String?
}
extension ImageRecognizedElementInfo {

    init?(json: JSON) {
        guard let name = json["name"].string else { return nil }
        self.name = name
        self.categoryId = nil
        self.position = nil
    }
}