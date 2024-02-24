//
//  EdfaPgSaleVirtualTransactionResult.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 09.03.2021.
//

import Foundation

/// The callback of the *EdfaPgVirtualSaleAdapter*.
///
/// See *EdfaPgCallback*
public typealias EdfaPgSaleVirtualTransactionResultCallback = EdfaPgCallback<EdfaPgSaleVirtualTransactionResult>

/// The result of the *EdfaPgVirtualSaleAdapter*.
public enum EdfaPgSaleVirtualTransactionResult: Codable {
    
    /// Success result.
    case success(EdfaPgSaleVirtualTransaction)
    
    /// Actual value: *EdfaPgGetTransactionStatusSuccess*
    public var result: EdfaPgResultProtocol {
        switch self {
        case .success(let result): return result
        }
    }
    
    public init(from decoder: Decoder) throws {
        self = try EdfaPgSaleTransactionVirtualDeserializer().decode(from: decoder)
    }
}
