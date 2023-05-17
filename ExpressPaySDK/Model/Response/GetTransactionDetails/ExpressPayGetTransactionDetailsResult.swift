//
//  ExpressPayGetTransactionDetailsResult.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 09.03.2021.
//

import Foundation

/// The callback of the *ExpressPayGetTransactionDetailsAdapter*.
/// 
/// @see *ExpressPayCallback*
public typealias ExpressPayGetTransactionDetailsCallback = ExpressPayCallback<ExpressPayGetTransactionDetailsResult>

/// The result of the *ExpressPayGetTransactionDetailsAdapter*.
public enum ExpressPayGetTransactionDetailsResult: Decodable {
    
    /// Success result.
    case success(ExpressPayGetTransactionDetailsSuccess)
    
    /// Actual value: *ExpressPayGetTransactionDetailsSuccess*
    public var result: OrderExpressPayResultProtocol {
        switch self {
        case .success(let result): return result
        }
    }
    
    public init(from decoder: Decoder) throws {
        self = try ExpressPayGetTransactionDetailsDeserializer().decode(from: decoder)
    }
}
