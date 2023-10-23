//
//  EdfaPgGetTransactionStatusResult.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 09.03.2021.
//

import Foundation

/// The callback of the *EdfaPgGetTransactionStatusAdapter*.
///
/// See *EdfaPgCallback*
public typealias EdfaPgGetTransactionStatusCallback = EdfaPgCallback<EdfaPgGetTransactionStatusResult>

/// The result of the *EdfaPgGetTransactionStatusAdapter*.
public enum EdfaPgGetTransactionStatusResult: Decodable {
    
    /// Success result.
    case success(EdfaPgGetTransactionStatusSuccess)
    
    /// Actual value: *EdfaPgGetTransactionStatusSuccess*
    public var result: EdfaPgResultProtocol {
        switch self {
        case .success(let result): return result
        }
    }
    
    public init(from decoder: Decoder) throws {
        self = try EdfaPgGetTransactionStatusDeserializer().decode(from: decoder)
    }
}
