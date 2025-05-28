//
//  EdfaPgResult.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 15.02.2021.
//

import Foundation

/// Result – value that system returns on request.
/// 
/// See *EdfaPgResultProtocol*
public enum EdfaPgResult: String, Codable {
    
    /// Action was successfully completed  in Payment Platform.
    case success = "SUCCESS"
    
    /// Result of unsuccessful action in Payment Platform.
    case declined = "DECLINED"
    
    /// Additional action required from requester (Redirect to 3ds).
    case redirect = "REDIRECT"
    
    /// Action was accepted by Payment Platform, but will be completed later.
    case accepted = "ACCEPTED"
    
    /// Request has errors and was not validated by Payment Platform.
    case error = "ERROR"
    
    /// Undefined Result
    case undefined
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = EdfaPgResult(rawValue: rawValue.uppercased()) ?? .undefined
    }
}
