//
//  EdfaPgTransactionStatus.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 15.02.2021.
//

import Foundation

/// The transaction status types.
/// 
/// See *EdfaPgTransaction*
public enum EdfaPgTransactionStatus: String, Codable {
    
    /// Failed or "0" status.
    case fail
    
    /// Success or "1" status.
    case success
    
    case undefined
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        let status = try? EdfaPgTransactionStatus(rawValue: rawValue.lowercased())
        self = status ?? .undefined
    }
}
