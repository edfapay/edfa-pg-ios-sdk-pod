//
//  ExpressPayResult.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 08.03.2021.
//

import Foundation

/// The base response result data holder description.
///
/// See *ExpressPayResponse*
public protocol ExpressPayResultProtocol {
    
    /// The action of the transaction.
    var action: ExpressPayAction { get }
    
    /// The result of the transaction.
    var result: ExpressPayResult { get }
    
    /// The status of the transaction.
    var status: ExpressPayStatus { get }
    
    /// Transaction ID in the Merchant’s system.
    var orderId: String { get }
    
    /// Transaction ID in the Payment Platform.
    var transactionId: String { get }
}
