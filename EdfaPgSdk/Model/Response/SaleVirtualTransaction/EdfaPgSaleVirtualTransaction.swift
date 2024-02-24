//
//  EdfaPgSaleVirtualTransactionSuccess.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 09.03.2021.
//

import Foundation

///
/// See *EdfaPgSaleVirtualTransactionResponse*
public struct EdfaPgSaleVirtualTransaction: EdfaPgResultProtocol {
    public let action: EdfaPgAction
    public let result: EdfaPgResult
    public let status: EdfaPgStatus
    public let orderId: String
    public let transactionId: String
    public let transactionDate: String?
    public let declineReason: String?
}

extension EdfaPgSaleVirtualTransaction: Codable {
    enum CodingKeys: String, CodingKey {
        case action, result, status
        case orderId = "order_id"
        case transactionId = "trans_id"
        case transactionDate = "trans_date"
        case declineReason = "decline_reason"
    }
}
