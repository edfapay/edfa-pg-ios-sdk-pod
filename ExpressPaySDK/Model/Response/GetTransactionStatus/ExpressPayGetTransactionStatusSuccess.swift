//
//  ExpressPayGetTransactionStatusSuccess.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 09.03.2021.
//

import Foundation

/// The GET_TRANS_STATUS success result of the *ExpressPayGetTransactionStatusResult*.
///
/// See *ExpressPayGetTransactionStatusResponse*
public struct ExpressPayGetTransactionStatusSuccess: ExpressPayResultProtocol {
    public let action: ExpressPayAction
    public let result: ExpressPayResult
    public let status: ExpressPayStatus
    public let orderId: String
    public let transactionId: String
}

extension ExpressPayGetTransactionStatusSuccess: Codable {
    enum CodingKeys: String, CodingKey {
        case action, result, status
        case orderId = "order_id"
        case transactionId = "trans_id"
    }
}
