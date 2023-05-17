//
//  ExpressPayGetTransactionDetailsService.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 09.03.2021.
//

import Foundation

/// GET_TRANS_DETAILS Service for the *ExpressPayGetTransactionDetailsAdapter*.
/// 
/// See *ExpressPayGetTransactionDetailsResponse*
///
/// Gets all history of transactions by the order.
public struct ExpressPayGetTransactionDetailsService: XWWWFormUrlEncodable {
    let action = ExpressPayAction.getTransDetails
    let clientKey = ExpressPaySDK.shared.credentials.clientKey
    let transactionId: String
    let hash: String
}

extension ExpressPayGetTransactionDetailsService: Encodable {
    enum CodingKeys: String, CodingKey {
        case hash, action
        case clientKey = "client_key"
        case transactionId = "trans_id"
    }
}
