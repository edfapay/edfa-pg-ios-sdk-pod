//
//  ExpressPayCard.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 15.02.2021.
//

import Foundation

/// The required card data holder.
/// For the test purposes use *ExpressPayTestCard*.
/// 
/// See *ExpressPaySaleAdapter*
public final class ExpressPayCard {
    
    /// The credit card number.
    public var number: String

    /// The month of expiry of the credit card. Month in the form XX.
    public var expireMonth: Int

    /// The year of expiry of the credit card. Year in the form XXXX.
    public var expireYear: Int
    
    /// The CVV/CVC2 credit card verification code. 3-4 symbols.
    public var cvv: String
    
    public init(number: String, expireMonth: Int, expireYear: Int, cvv: String) {
        self.number = number
        self.expireMonth = expireMonth
        self.expireYear = expireYear
        self.cvv = cvv
    }
}
