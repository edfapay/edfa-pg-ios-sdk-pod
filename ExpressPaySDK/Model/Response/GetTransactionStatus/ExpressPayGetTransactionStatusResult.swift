//
//  ExpressPayGetTransactionStatusResult.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 09.03.2021.
//

import Foundation

/// The callback of the *ExpressPayGetTransactionStatusAdapter*.
///
/// See *ExpressPayCallback*
public typealias ExpressPayGetTransactionStatusCallback = ExpressPayCallback<ExpressPayGetTransactionStatusResult>

/// The result of the *ExpressPayGetTransactionStatusAdapter*.
public enum ExpressPayGetTransactionStatusResult: Decodable {
    
    /// Success result.
    case success(ExpressPayGetTransactionStatusSuccess)
    
    /// Actual value: *ExpressPayGetTransactionStatusSuccess*
    public var result: ExpressPayResultProtocol {
        switch self {
        case .success(let result): return result
        }
    }
    
    public init(from decoder: Decoder) throws {
        self = try ExpressPayGetTransactionStatusDeserializer().decode(from: decoder)
    }
}
