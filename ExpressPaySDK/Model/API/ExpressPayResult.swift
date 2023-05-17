//
//  ExpressPayResult.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 15.02.2021.
//

import Foundation

/// Result – value that system returns on request.
/// 
/// See *ExpressPayResultProtocol*
public enum ExpressPayResult: String, Codable {
    
    /// Action was successfully completed  in Payment Platform.
    case success = "SUCCESS"
    
    /// Result of unsuccessful action in Payment Platform.
    case declined = "DECLINED"
    
    /// Additional action required from requester (Redirect to 3ds).
    case rejected = "REDIRECT"
    
    /// Action was accepted by Payment Platform, but will be completed later.
    case accepted = "ACCEPTED"
    
    /// Request has errors and was not validated by Payment Platform.
    case error = "ERROR"
}
