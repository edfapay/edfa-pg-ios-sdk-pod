//
//  EdfaPgCreditvoidSuccess.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 09.03.2021.
//

import Foundation

/// The CREDITVOID success result of the *EdfaPgCreditvoidResult*.
///
/// See *EdfaPgCreditvoidResponse*
public struct EdfaPgCreditvoidSuccess: EdfaPgResultProtocol {
    public let action: EdfaPgAction
    public let result: EdfaPgResult
    public let status: EdfaPgStatus
    public let orderId: String
    public let transactionId: String
}

extension EdfaPgCreditvoidSuccess: Codable {
    enum CodingKeys: String, CodingKey {
        case action, result, status
        case orderId = "order_id"
        case transactionId = "trans_id"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        action = try container.decode(EdfaPgAction.self, forKey: .action)
        result = try container.decode(EdfaPgResult.self, forKey: .result)
        orderId = try container.decode(String.self, forKey: .orderId)
        transactionId = try container.decode(String.self, forKey: .transactionId)
        status = try container.decodeIfPresent(EdfaPgStatus.self, forKey: .status) ?? .undefined
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(action, forKey: .action)
        try container.encode(result, forKey: .result)
        try container.encode(orderId, forKey: .orderId)
        try container.encode(transactionId, forKey: .transactionId)
        try container.encodeIfPresent(status, forKey: .status)
    }
}
