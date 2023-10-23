//
//  EdfaPgResult.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 08.03.2021.
//

import Foundation

/// The base response result data holder description.
///
/// See *EdfaPgResponse*
public protocol EdfaPgResultProtocol {
    
    /// The action of the transaction.
    var action: EdfaPgAction { get }
    
    /// The result of the transaction.
    var result: EdfaPgResult { get }
    
    /// The status of the transaction.
    var status: EdfaPgStatus { get }
    
    /// Transaction ID in the Merchant’s system.
    var orderId: String { get }
    
    /// Transaction ID in the Payment Platform.
    var transactionId: String { get }
}
