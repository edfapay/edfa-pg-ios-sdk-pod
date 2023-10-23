//
//  EdfaPgCaptureSuccess.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 08.03.2021.
//

import Foundation

/// The CAPTURE success result of the *EdfaPgCaptureResult*.
/// 
/// See *EdfaPgCaptureResponse*
public struct EdfaPgCaptureSuccess: DetailsEdfaPgResultProtocol {
    public let transactionDate: Date
    
    public let descriptor: String?
    
    public let orderAmount: Double
    
    public let orderCurrency: String
    
    public let action: EdfaPgAction
    
    public let result: EdfaPgResult
    
    public let status: EdfaPgStatus
    
    public let orderId: String
    
    public let transactionId: String
}

extension EdfaPgCaptureSuccess: Codable {
    enum CodingKeys: String, CodingKey {
        case descriptor
        case transactionDate = "trans_date"
        case orderAmount = "amount"
        case orderCurrency = "currency"
        case action
        case result
        case status
        case orderId = "order_id"
        case transactionId = "trans_id"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        orderCurrency = try container.decode(String.self, forKey: .orderCurrency)
        action = try container.decode(EdfaPgAction.self, forKey: .action)
        result = try container.decode(EdfaPgResult.self, forKey: .result)
        status = try container.decode(EdfaPgStatus.self, forKey: .status)
        orderId = try container.decode(String.self, forKey: .orderId)
        transactionId = try container.decode(String.self, forKey: .transactionId)
        
        transactionDate = EdfaPgDateFormatter.date(from: try container.decode(String.self, forKey: .transactionDate)) ?? Date()
        orderAmount = Double(try container.decode(String.self, forKey: .orderAmount)) ?? 0
        
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
