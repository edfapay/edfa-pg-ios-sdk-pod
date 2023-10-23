//
//  EdfaPgExactError.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 08.03.2021.
//

import Foundation

/// The exact error data holder.
///
/// See *EdfaPgResponse, EdfaPgBaseAdapter, EdfaPgError*
public struct EdfaPgExactError: Error {
    
    /// Code error code.
    public let code: Int
    
    /// Error message.
    public let message: String
}

extension EdfaPgExactError: Codable {
    enum CodingKeys: String, CodingKey {
        case code = "error_code"
        case message = "error_message"
    }
}
