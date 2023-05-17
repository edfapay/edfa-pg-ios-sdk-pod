//
//  ExpressPayOrder.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 15.02.2021.
//

import Foundation

/// The required order data holder.
///
/// See *ExpressPayRecurringSaleAdapter, ExpressPayOrderProtocol*
public class ExpressPayOrder: ExpressPayOrderProtocol {
    
    /// Transaction ID in the Merchants system. String up to 255 characters.
    public var id: String
    
    /// The amount of the transaction. Numbers in the form XXXX.XX (without leading zeros).
    public var amount: Double
    
    /// Description of the transaction (product name). String up to 1024 characters.
    public var description: String
    
    /// Create the required order data holder.
    /// - Parameters:
    ///   - id: Transaction ID in the Merchants system. String up to 255 characters.
    ///   - amount: The amount of the transaction. Numbers in the form XXXX.XX (without leading zeros).
    ///   - description: Description of the transaction (product name). String up to 1024 characters.
    public init(id: String, amount: Double, description: String) {
        self.id = id
        self.amount = amount
        self.description = description
    }
}
