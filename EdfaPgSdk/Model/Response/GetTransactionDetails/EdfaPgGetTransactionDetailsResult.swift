//
//  EdfaPgGetTransactionDetailsResult.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 09.03.2021.
//

import Foundation

/// The callback of the *EdfaPgGetTransactionDetailsAdapter*.
/// 
/// @see *EdfaPgCallback*
public typealias EdfaPgGetTransactionDetailsCallback = EdfaPgCallback<EdfaPgGetTransactionDetailsResult>

/// The result of the *EdfaPgGetTransactionDetailsAdapter*.
public enum EdfaPgGetTransactionDetailsResult: Decodable {
    
    /// Success result.
    case success(EdfaPgGetTransactionDetailsSuccess)
    
    /// Actual value: *EdfaPgGetTransactionDetailsSuccess*
    public var result: OrderEdfaPgResultProtocol {
        switch self {
        case .success(let result): return result
        }
    }
    
    public init(from decoder: Decoder) throws {
        self = try EdfaPgGetTransactionDetailsDeserializer().decode(from: decoder)
    }
}
