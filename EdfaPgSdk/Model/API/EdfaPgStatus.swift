//
//  EdfaPgStatus.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 15.02.2021.
//

import Foundation

/// Status – actual status of transaction in Payment Platform.
///
/// See *EdfaPgResultProtocol*
public enum EdfaPgStatus: String, Codable {
    
    /// The transaction awaits 3D-Secure validation.
    case secure3D = "3DS"
    
    /// The transaction is redirected.
    case redirect = "REDIRECT"
    
    /// The transaction awaits CAPTURE.
    case pending = "PENDING"
    
    /// Successful transaction.
    case settled = "SETTLED"
    
    /// Transaction for which reversal was made.
    case reversal = "REVERSAL"
    
    /// Transaction for which refund was made.
    case refund = "REFUND"
    
    /// Transaction for which chargeback was made.
    case chargeback = "CHARGEBACK"
    
    /// Not successful transaction.
    case declined = "DECLINED"
    
    /// Undefined status
    case undefined
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = EdfaPgStatus(rawValue: rawValue.uppercased()) ?? .undefined
    }
}
