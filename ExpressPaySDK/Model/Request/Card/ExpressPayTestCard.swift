//
//  ExpressPayTestCard.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 15.02.2021.
//

import Foundation

/// The test environment cards.
///
/// See *ExpressPayCard*
public struct ExpressPayTestCard {
    
    /// This card number and card expiration date must be used for testing successful sale.
    ///
    /// Response on successful SALE request: "action": "SALE", "result": "SUCCESS", "status": "SETTLED".
    ///
    /// Response on successful AUTH request: "action": "SALE", "result": "SUCCESS", "status": "PENDING".
    public static var saleSuccess: ExpressPayCard {
        ExpressPayCard(number: testCardNumber, expireMonth: 1, expireYear: testCardYear, cvv: testCardCvv)
    }
    
    /// This card number and card expiration date must be used for testing unsuccessful sale.
    ///
    /// Response on unsuccessful SALE request: "action": "SALE", "result": "DECLINED", "status": "DECLINED".
    ///
    /// Response on unsuccessful AUTH request: "action": "SALE", "result": "DECLINED", "status": "DECLINED".
    public static var saleFailure: ExpressPayCard {
        ExpressPayCard(number: testCardNumber, expireMonth: 2, expireYear: testCardYear, cvv: testCardCvv)
    }
    
    /// This card number and card expiration date must be used for testing unsuccessful CAPTURE after successful AUTH.
    ///
    /// Response on successful AUTH request: "action": "SALE", "result": "SUCCESS", "status": "PENDING".
    ///
    /// Response on unsuccessful CAPTURE request: "action": "CAPTURE", "result": "DECLINED", "status": "PENDING".
    public static var captureFailure: ExpressPayCard {
        ExpressPayCard(number: testCardNumber, expireMonth: 3, expireYear: testCardYear, cvv: testCardCvv)
    }
    
    /// This card number and card expiration date must be used for testing  successful sale after 3DS verification.
    ///
    /// Response on VERIFY request: "action": "SALE", "result": "REDIRECT", "status": "3DS".
    ///
    /// After return from ACS: "action": "SALE", "result": "SUCCESS", "status": "SETTLED".
    public static var secure3dSuccess: ExpressPayCard {
        ExpressPayCard(number: testCardNumber, expireMonth: 5, expireYear: testCardYear, cvv: testCardCvv)
    }
    
    /// This card number and card expiration date must be used for testing unsuccessful sale after 3DS verification.
    ///
    /// Response on VERIFY request: "action": "SALE", "result": "REDIRECT", "status": "3DS".
    ///
    /// After return from ACS: "action": "SALE", "result": "DECLINED", "status": "DECLINED".
    public static var secure3dFailure: ExpressPayCard {
        ExpressPayCard(number: testCardNumber, expireMonth: 6, expireYear: testCardYear, cvv: testCardCvv)
    }
    
    private static let testCardNumber = "4111111111111111"
    private static let testCardYear = 2025
    private static let testCardCvv = "411"
}
