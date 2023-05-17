//
//  ExpressPayExactError.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 08.03.2021.
//

import Foundation

/// The exact error data holder.
///
/// See *ExpressPayResponse, ExpressPayBaseAdapter, ExpressPayError*
public struct ExpressPayExactError: Error {
    
    /// Code error code.
    public let code: Int
    
    /// Error message.
    public let message: String
}

extension ExpressPayExactError: Codable {
    enum CodingKeys: String, CodingKey {
        case code = "error_code"
        case message = "error_message"
    }
}
