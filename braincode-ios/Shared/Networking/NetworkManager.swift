//
//  NetworkManager.swift
//  braincode-ios
//
//  Created by Kacper Harasim on 18.03.2016.
//  Copyright © 2016 Kacper Harasim. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import SwiftyJSON
import RxAlamofire


enum NetworkManagerError: ErrorType, CustomStringConvertible {

    case BadResponse(code: Int)

    var description: String {
        return ""
    }
}

class NetworkManager {
    
    private static let baseAddress = "http://10.3.8.27:5000/"

    enum Endpoint: String {
        case Compute = "compute"

        var path: String {
            return baseAddress + self.rawValue
        }
    }

    func basicRequest(endpoint: Endpoint) -> Observable<JSON> {

        return requestJSON(.POST, endpoint.path).flatMap { response, json -> Observable<JSON> in
            if response.statusCode != 200 {
                return Observable.error(NetworkManagerError.BadResponse(code: response.statusCode))
            }
            return Observable.just(JSON(json))
        }
    }

}