//
//  EdfaPgTransactionType.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 15.02.2021.
//

import Foundation

/// The transaction type types.
/// 
/// See *.EdfaPgTransaction*
public enum EdfaPgTransactionType: String, Codable {
    
    /// 3DS transaction type.
    case secure3d = "SECURE_3D"
    
    /// 3DS transaction type.
    case threeDs = "3DS"
    
    /// SALE transaction type.
    case sale = "SALE"
    
    /// AUTH transaction type.
    case auth = "AUTH"
    
    /// CAPTURE transaction type.
    case capture = "CAPTURE"
    
    /// REVERSAL transaction type.
    case reversal = "REVERSAL"
     
    /// REFUND transaction type.
    case refund = "REFUND"
     
    /// REFUND transaction type.
    case redirect = "REDIRECT"
    
    /// CHARGEBACK transaction type.
    case chargeback = "CHARGEBACK"
    
    /// Undefined Type
    case undefined
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = EdfaPgTransactionType(rawValue: rawValue.uppercased()) ?? .undefined
    }
}
