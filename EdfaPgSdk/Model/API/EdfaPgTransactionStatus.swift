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
}
