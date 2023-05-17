//
//  ExpressPayGetTransactionStatusService.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 09.03.2021.
//

import Foundation

/// GET_TRANS_STATUS Service for the *ExpressPayGetTransactionStatusAdapter*.
/// 
/// See *ExpressPayGetTransactionStatusResponse*
///
/// Gets order status from Payment Platform.
public struct ExpressPayGetTransactionStatusService: XWWWFormUrlEncodable {
    let action = ExpressPayAction.getTransStatus
    let clientKey = ExpressPaySDK.shared.credentials.clientKey
    let transactionId: String
    let hash: String
}

extension ExpressPayGetTransactionStatusService: Encodable {
    enum CodingKeys: String, CodingKey {
        case hash, action
        case clientKey = "client_key"
        case transactionId = "trans_id"
    }
}
