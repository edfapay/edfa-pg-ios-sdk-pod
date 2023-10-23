//
//  EdfaPgTransaction.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 09.03.2021.
//

import Foundation

/// The transaction data holder.
/// 
/// See *EdfaPgGetTransactionDetailsSuccess*
public struct EdfaPgTransaction {
    
    /// Transaction date.
    public let date: Date

    /// Transaction type (sale, 3ds, auth, capture, chargeback, reversal, refund).
    public let type: EdfaPgTransactionType

    /// Transaction status (0-fail, 1-success).
    public let status: EdfaPgTransactionStatus
    
    /// Transaction amount.
    public let amount: Double
}

extension EdfaPgTransaction: Codable {
    enum CodingKeys: String, CodingKey {
        case date, type, status, amount
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        type = try container.decode(EdfaPgTransactionType.self, forKey: .type)
        status = try container.decode(EdfaPgTransactionStatus.self, forKey: .status)

        amount = Double(try container.decode(String.self, forKey: .amount)) ?? 0
        date = EdfaPgDateFormatter.date(from: try container.decode(String.self, forKey: .date)) ?? Date()
    }
    
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try? container.encode(status, forKey: .status)
        try container.encode(amount, forKey: .amount)
        try container.encode(EdfaPgDateFormatter.string(from: date), forKey: .date)

    }
}
