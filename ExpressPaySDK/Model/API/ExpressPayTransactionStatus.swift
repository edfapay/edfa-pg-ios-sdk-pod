//
//  ExpressPayTransactionStatus.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 15.02.2021.
//

import Foundation

/// The transaction status types.
/// 
/// See *ExpressPayTransaction*
public enum ExpressPayTransactionStatus: String, Codable {
    
    /// Failed or "0" status.
    case fail
    
    /// Success or "1" status.
    case success
}
