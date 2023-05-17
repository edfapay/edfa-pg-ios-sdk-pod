//
//  ExpressPayCreditvoidResult.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 09.03.2021.
//

import Foundation

/// The callback of the *ExpressPayCreditvoidAdapter*.
///
/// See *ExpressPayCallback*
public typealias ExpressPayCreditvoidCallback = ExpressPayCallback<ExpressPayCreditvoidResult>

/// The result of the*ExpressPayCreditvoidAdapter*.
public enum ExpressPayCreditvoidResult: Decodable {
    
    /// Success result.
    case success(ExpressPayCreditvoidSuccess)
    
    /// Actual value: *ExpressPayCreditvoidSuccess*.
    public var result: ExpressPayResultProtocol {
        switch self {
        case .success(let result): return result
        }
    }
    
    public init(from decoder: Decoder) throws {
        self = try ExpressPayCreditvoidDeserializer().decode(from: decoder)
    }
}
