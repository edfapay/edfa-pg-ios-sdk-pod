//
//  ExpressPayCreditvoidSuccess.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 09.03.2021.
//

import Foundation

/// The CREDITVOID success result of the *ExpressPayCreditvoidResult*.
///
/// See *ExpressPayCreditvoidResponse*
public struct ExpressPayCreditvoidSuccess: ExpressPayResultProtocol {
    public let action: ExpressPayAction
    public let result: ExpressPayResult
    public let status: ExpressPayStatus
    public let orderId: String
    public let transactionId: String
}

extension ExpressPayCreditvoidSuccess: Codable {
    enum CodingKeys: String, CodingKey {
        case action, result, status
        case orderId = "order_id"
        case transactionId = "trans_id"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        action = try container.decode(ExpressPayAction.self, forKey: .action)
        result = try container.decode(ExpressPayResult.self, forKey: .result)
        orderId = try container.decode(String.self, forKey: .orderId)
        transactionId = try container.decode(String.self, forKey: .transactionId)
        status = try container.decodeIfPresent(ExpressPayStatus.self, forKey: .status) ?? .undefined
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = try encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(action, forKey: .action)
        try container.encode(result, forKey: .result)
        try container.encode(orderId, forKey: .orderId)
        try container.encode(transactionId, forKey: .transactionId)
        try container.encodeIfPresent(status, forKey: .status)
    }
}
