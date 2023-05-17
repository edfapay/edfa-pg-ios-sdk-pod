//
//  DetailsExpressPayResultProtocol.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 08.03.2021.
//

import Foundation

/// The base response details result data holder description.
///
/// See *ExpressPayResponse, OrderExpressPayResultProtocol*
public protocol DetailsExpressPayResultProtocol: OrderExpressPayResultProtocol {
    
    /// Transaction date in the Payment Platform.
    var transactionDate: Date { get }
    
    /// Descriptor from the bank, the same as cardholder will see in the bank statement. Optional.
    var descriptor: String? { get }
}
