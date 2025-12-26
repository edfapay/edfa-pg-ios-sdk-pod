//
//  EdfaPgAction.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 15.02.2021.
//

import Foundation

/// When you make request to Payment Platform, you need to specify action, that needs to be done.
/// Basically, every action is represented by its Adapter.
/// 
/// See *EdfaPgSdk, EdfaPgResultProtocol*
public enum EdfaPgAction: String, Codable {
    
    /// Creates SADAD just for identification, not used ad action in request
    case sadad = "SADAD"
    
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
    
    /// Undefined Action
    case undefined
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = EdfaPgAction(rawValue: rawValue.uppercased()) ?? .undefined
    }
}
