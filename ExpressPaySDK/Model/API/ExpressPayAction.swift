//
//  ExpressPayAction.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 15.02.2021.
//

import Foundation

/// When you make request to Payment Platform, you need to specify action, that needs to be done.
/// Basically, every action is represented by its Adapter.
/// 
/// See *ExpressPaySdk, ExpressPayResultProtocol*
public enum ExpressPayAction: String, Codable {
    
    /// Creates SALE or AUTH transaction.
    case sale = "SALE"
    
    /// Creates CAPTURE transaction.
    case capture = "CAPTURE"
    
    /// Creates REVERSAL or REFUND transaction.
    case creditvoid = "CREDITVOID"
    
    /// Gets status of transaction in Payment Platform.
    case getTransStatus = "GET_TRANS_STATUS"
    
    /// Gets details of the order from Payment platform.
    case getTransDetails = "GET_TRANS_DETAILS"
    
    /// Creates SALE or AUTH transaction using previously used cardholder data.
    case recurringSale = "RECURRING_SALE"
    
    /// Following actions can not be made by request, they are created by Payment Platform in certain circumstances
    /// (e.g. issuer initiated chargeback) and you receive callback as a result.
    case chargeback = "CHARGEBACK"
}
