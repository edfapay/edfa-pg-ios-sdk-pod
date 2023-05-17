//
//  ExpressPayTransaction.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 09.03.2021.
//

import Foundation

/// The transaction data holder.
/// 
/// See *ExpressPayGetTransactionDetailsSuccess*
public struct ExpressPayTransaction {
    
    /// Transaction date.
    public let date: Date

    /// Transaction type (sale, 3ds, auth, capture, chargeback, reversal, refund).
    public let type: ExpressPayTransactionType

    /// Transaction status (0-fail, 1-success).
    public let status: ExpressPayTransactionStatus
    
    /// Transaction amount.
    public let amount: Double
}

extension ExpressPayTransaction: Codable {
    enum CodingKeys: String, CodingKey {
        case date, type, status, amount
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        type = try container.decode(ExpressPayTransactionType.self, forKey: .type)
        status = try container.decode(ExpressPayTransactionStatus.self, forKey: .status)

        amount = Double(try container.decode(String.self, forKey: .amount)) ?? 0
        date = ExpressPayDateFormatter.date(from: try container.decode(String.self, forKey: .date)) ?? Date()
    }
    
    
    public func encode(to encoder: Encoder) throws {
        var container = try encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try? container.encode(status, forKey: .status)
        try container.encode(amount, forKey: .amount)
        try container.encode(ExpressPayDateFormatter.string(from: date), forKey: .date)

    }
}
