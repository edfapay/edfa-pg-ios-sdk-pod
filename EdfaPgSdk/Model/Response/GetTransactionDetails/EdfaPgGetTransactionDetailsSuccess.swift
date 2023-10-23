//
//  EdfaPgGetTransactionDetailsSuccess.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 09.03.2021.
//

import Foundation

/// The GET_TRANS_DETAILS success result of the *EdfaPgGetTransactionDetailsResult*.
/// 
/// See *EdfaPgGetTransactionDetailsResponse, EdfaPgTransaction*
///
/// @property name
/// @property mail p
/// @property ip p
/// @property card p
/// @property transactions t
public struct EdfaPgGetTransactionDetailsSuccess: OrderEdfaPgResultProtocol {
  
    public let action: EdfaPgAction
    
    public var result: EdfaPgResult
    
    public var status: EdfaPgStatus
    
    public let orderId: String
    
    public let transactionId: String
    
    public let declineReason: String?
    
    /// Payer name.
    public let name: String
    
    /// Payer mail.
    public let mail: String
    
    /// Payer IP.
    public let ip: String
    
    public let orderAmount: Double
    
    public let orderCurrency: String
    
    /// Payer card number. Format: XXXXXXXX****XXXX.
    public let card: String
    
    /// The *EdfaPgTransaction* list.
    public let transactions: [EdfaPgTransaction]
}

extension EdfaPgGetTransactionDetailsSuccess: Codable {
    enum CodingKeys: String, CodingKey {
        case action, result, status, name, mail, ip, card, transactions
        case orderAmount = "amount"
        case orderCurrency = "currency"
        case orderId = "order_id"
        case transactionId = "trans_id"
        case declineReason = "decline_reason"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        action = try container.decode(EdfaPgAction.self, forKey: .action)
        result = try container.decode(EdfaPgResult.self, forKey: .result)
        status = try container.decode(EdfaPgStatus.self, forKey: .status)
        orderId = try container.decode(String.self, forKey: .orderId)
        transactionId = try container.decode(String.self, forKey: .transactionId)
        name = try container.decode(String.self, forKey: .name)
        mail = try container.decode(String.self, forKey: .mail)
        ip = try container.decode(String.self, forKey: .ip)
        orderCurrency = try container.decode(String.self, forKey: .orderCurrency)
        card = try container.decode(String.self, forKey: .card)
        transactions = try container.decode([EdfaPgTransaction].self, forKey: .transactions)

        declineReason = try? container.decode(String.self, forKey: .declineReason)
        
        orderAmount = Double(try container.decode(String.self, forKey: .orderAmount)) ?? 0
    }
    
//    public func encode(to encoder: Encoder) throws {
//        var container = try encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(orderAmount, forKey: .orderAmount)
//    }
}
