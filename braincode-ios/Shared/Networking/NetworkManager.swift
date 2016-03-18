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
    case MultipartDataSendFailed(ErrorType)
    case MultipartResponseFailure(ErrorType)
    case JSONParsingError

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

    func sendDataMultipart(data: NSData) -> Observable<JSON> {

        var cancelRequestToken: Request?
        return Observable.create { observer in
            Alamofire.upload(
                .POST,
                "https://httpbin.org/post",
                multipartFormData: { multipartFormData in
                    multipartFormData.appendBodyPart(data: data, name: "img")
                },
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        cancelRequestToken = upload.responseJSON { response in
                            switch response.result {
                            case let .Success(val):
                                let json = JSON(val)
                                observer.onNext(json)
                                observer.onCompleted()
                            case .Failure(let error):
                                observer.onError(NetworkManagerError.MultipartDataSendFailed(error))
                            }
                        }
                    case .Failure(let encodingError):
                        observer.onError(NetworkManagerError.MultipartDataSendFailed(encodingError))
                    }
                })
            return AnonymousDisposable {
                cancelRequestToken?.cancel()
            }

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