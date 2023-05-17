//
//  ExpressPayPayerOptions.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 15.02.2021.
//

import Foundation

/// The optional payer options data holder.
/// 
/// See *ExpressPaySaleAdapter, ExpressPayPayer*
public final class ExpressPayPayerOptions {
    
    /// Customer’s middle name. String up to 32 characters.
    public var middleName: String?
    
    /// Customer’s birthday. Format: yyyy-MM-dd, e.g. 1970-02-17.
    public var birthdate: Date?
    
    /// The adjoining road or locality of the сustomer’s address. String up to 255 characters.
    public var address2: String?
    
    /// Customer’s state. String up to 32 characters.
    public var state: String?
    
    /// Create the optional payer options data holder.
    /// - Parameters:
    ///   - middleName: Customer’s middle name. String up to 32 characters.
    ///   - birthdate: Customer’s birthday. Format: yyyy-MM-dd, e.g. 1970-02-17.
    ///   - address2: The adjoining road or locality of the сustomer’s address. String up to 255 characters.
    ///   - state: Customer’s state. String up to 32 characters.
    public init(middleName: String? = nil, birthdate: Date? = nil, address2: String? = nil, state: String? = nil) {
        self.middleName = middleName
        self.birthdate = birthdate
        self.address2 = address2
        self.state = state
    }
    
    func jsonForVirtualPurchase() -> [String:Any]{
        return [
            "middleName" : middleName ?? "",
            "birthdate" : birthdate?.description ?? "",
            "address2" : address2 ?? "",
            "state" : state ?? "",
        ]
    }
}
