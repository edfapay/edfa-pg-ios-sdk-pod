//
//  ExpressPayCallback.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 15.02.2021.
//

import Foundation

/// ExpressPayCallback
/// - Result: the successful result type of the *Response*
public typealias ExpressPayCallback<Result: Decodable> = (ExpressPayResponse<Result>) -> Void

/// ExpressPayResponse
/// - Result: the successful result type of the *Response*
public enum ExpressPayResponse<Result: Decodable> {
    
    /// The custom suucess result case
    case result(Result)
    
    /// The custom error result case
    case error(ExpressPayError)
    
    /// The unhandled exception case
    case failure(Error)
}
