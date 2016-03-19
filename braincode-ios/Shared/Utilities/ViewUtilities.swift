//
//  ViewUtilities.swift
//  braincode-ios
//
//  Created by Kacper Harasim on 18.03.2016.
//  Copyright © 2016 Kacper Harasim. All rights reserved.
//

import Foundation
import UIKit


extension CGRect {
    func translateBy(x: CGFloat, _ y: CGFloat) -> CGRect {
        return CGRect(x: self.origin.x + x, y: self.origin.y + y, width: self.width, height: self.height)
    }
}