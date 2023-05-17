//
//  ExpressPaySaleOrder.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 15.02.2021.
//

import Foundation

/// The sale order data holder.
///
/// See *ExpressPaySaleAdapter, ExpressPayOrderProtocol*
public final class ExpressPaySaleOrder: ExpressPayOrder {
    
    /// The currency. 3-letter code.
    public var currency: String
    
    /// The currency. 2-letter code.
    public var country: String
    
    /// Create the sale order data holder.
    /// - Parameters:
    ///   - id: Transaction ID in the Merchants system. String up to 255 characters.
    ///   - amount: The amount of the transaction. Numbers in the form XXXX.XX (without leading zeros).
    ///   - currency: The currency. 3-letter code.
    ///   - description: Description of the transaction (product name). String up to 1024 characters.
    public init(id: String, amount: Double, currency: String, description: String) {
        self.currency = currency
        self.country = String(self.currency.dropLast(1))
        
        super.init(id: id, amount: amount, description: description)
    }
    
    public init(id: String, amount: Double, currency: String, country: String, description: String) {
        self.currency = currency
        self.country = country
        
        super.init(id: id, amount: amount, description: description)
    }
    
    func jsonForVirtualPurchase() -> [String:Any]{
        
        return [
            "number": id,
            "amount": formatedAmountString(),
            "currency": currency,
            "country": country,
            "description": description
        ]
    }
    
    func formatedAmountString() -> String{
        let formatter = NumberFormatter()
        formatter.currencyCode = currency
        formatter.numberStyle = .currency

        let value = String(format: "%.\(formatter.minimumFractionDigits)f", amount)
        return value
    }
}
