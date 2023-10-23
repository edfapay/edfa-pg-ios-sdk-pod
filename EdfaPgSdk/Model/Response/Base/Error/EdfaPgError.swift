//
//  EdfaPgError.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 15.02.2021.
//

import Foundation

/// The error response data holder.
///
/// Presented as the param in *EdfaPgResponse.error*.
///
/// See *EdfaPgResponse, EdfaPgBaseAdapter, EdfaPgExactError*
public struct EdfaPgError: Error {
    
    /// Always *EdfaPgResult.error*.
    public let result: EdfaPgResult
    
    /// Error code.
    public let code: Int
    
    /// Error message.
    public let message: String
    
    /// :ist of the *EdfaPgExactError*.
    public let exactErrors: [EdfaPgExactError]
    
    /// Default *Error* description property
    public var localizedDescription: String { message }
}

extension EdfaPgError: Codable {
    enum CodingKeys: String, CodingKey {
        case result
        case code = "error_code"
        case message = "error_message"
        case exactErrors = "errors"
    }
}
