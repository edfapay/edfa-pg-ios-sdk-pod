//
//  ExpressPayError.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 15.02.2021.
//

import Foundation

/// The error response data holder.
///
/// Presented as the param in *ExpressPayResponse.error*.
///
/// See *ExpressPayResponse, ExpressPayBaseAdapter, ExpressPayExactError*
public struct ExpressPayError: Error {
    
    /// Always *ExpressPayResult.error*.
    public let result: ExpressPayResult
    
    /// Error code.
    public let code: Int
    
    /// Error message.
    public let message: String
    
    /// :ist of the *ExpressPayExactError*.
    public let exactErrors: [ExpressPayExactError]
    
    /// Default *Error* description property
    public var localizedDescription: String { message }
}

extension ExpressPayError: Codable {
    enum CodingKeys: String, CodingKey {
        case result
        case code = "error_code"
        case message = "error_message"
        case exactErrors = "errors"
    }
}
