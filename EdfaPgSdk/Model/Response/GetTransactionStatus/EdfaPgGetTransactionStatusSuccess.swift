//
//  EdfaPgGetTransactionStatusSuccess.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 09.03.2021.
//

import Foundation

/// The GET_TRANS_STATUS success result of the *EdfaPgGetTransactionStatusResult*.
///
/// See *EdfaPgGetTransactionStatusResponse*
public struct EdfaPgGetTransactionStatusSuccess: EdfaPgResultProtocol {
    public let action: EdfaPgAction
    public let result: EdfaPgResult
    public let status: EdfaPgStatus
    public let orderId: String
    public let transactionId: String
}

extension EdfaPgGetTransactionStatusSuccess: Codable {
    enum CodingKeys: String, CodingKey {
        case action, result, status
        case orderId = "order_id"
        case transactionId = "trans_id"
    }
}
