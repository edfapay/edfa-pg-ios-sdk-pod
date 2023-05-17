//
//  ExpressPayCaptureResult.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 08.03.2021.
//

import Foundation

/// The callback of the *ExpressPayCaptureAdapter*.
///
/// See *ExpressPayCallback*
public typealias ExpressPayCaptureCallback = ExpressPayCallback<ExpressPayCaptureResult>

/// The result of the *ExpressPayCaptureAdapter*.
public enum ExpressPayCaptureResult: Decodable {
    
    /// Success result.
    case success(ExpressPayCaptureSuccess)
    
    /// Decline result.
    case decline(ExpressPaySaleDecline)
    
    /// Actual result value: *ExpressPayCaptureSuccess* or *ExpressPaySaleDecline*
    public var result: DetailsExpressPayResultProtocol {
        switch self {
        case .success(let result): return result
        case .decline(let result): return result
        }
    }
    
    public init(from decoder: Decoder) throws {
        self = try ExpressPayCaptureDeserializer().decode(from: decoder)
    }
}
