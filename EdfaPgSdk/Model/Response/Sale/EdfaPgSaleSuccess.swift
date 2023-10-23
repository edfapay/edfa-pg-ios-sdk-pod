//
//  EdfaPgSaleSuccess.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 09.03.2021.
//

import Foundation

public struct EdfaPgSaleSuccess: DetailsEdfaPgResultProtocol {
    
    public let action: EdfaPgAction
    
    public let result: EdfaPgResult
    
    public let status: EdfaPgStatus
    
    public let orderId: String
    
    public let transactionId: String
    
    public let transactionDate: Date
    
    public let descriptor: String?
    
    public let orderAmount: Double
    
    public let orderCurrency: String
}

extension EdfaPgSaleSuccess: Codable {
    enum CodingKeys: String, CodingKey {
        case action, result, status, descriptor
        case orderId = "order_id"
        case transactionId = "trans_id"
        case transactionDate = "trans_date"
        case orderAmount = "amount"
        case orderCurrency = "currency"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        action = try container.decode(EdfaPgAction.self, forKey: .action)
        result = try container.decode(EdfaPgResult.self, forKey: .result)
        status = try container.decode(EdfaPgStatus.self, forKey: .status)
        orderId = try container.decode(String.self, forKey: .orderId)
        transactionId = try container.decode(String.self, forKey: .transactionId)
        orderCurrency = try container.decode(String.self, forKey: .orderCurrency)
        
        orderAmount = Double(try container.decode(String.self, forKey: .orderAmount)) ?? 0
        transactionDate = EdfaPgDateFormatter.date(from: try container.decode(String.self, forKey: .transactionDate)) ?? Date()

        descriptor = try container.decodeIfPresent(String.self, forKey: .descriptor)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(action, forKey: .action)
        try container.encode(status, forKey: .status)
        try container.encode(result, forKey: .result)
        try container.encode(orderId, forKey: .orderId)
        try container.encode(transactionId, forKey: .transactionId)
        try container.encode(orderCurrency, forKey: .orderCurrency)
        
        try container.encode(orderAmount, forKey: .orderAmount)
        try container.encode(EdfaPgDateFormatter.string(from: transactionDate), forKey: .transactionDate)
        
        try container.encode(descriptor, forKey: .descriptor)
    }
}
