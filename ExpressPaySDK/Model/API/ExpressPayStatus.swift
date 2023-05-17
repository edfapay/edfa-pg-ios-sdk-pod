//
//  ExpressPayStatus.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 15.02.2021.
//

import Foundation

/// Status – actual status of transaction in Payment Platform.
///
/// See *ExpressPayResultProtocol*
public enum ExpressPayStatus: String, Codable {
    
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
}
