//
//  EdfaPgGetTransactionDetailsService.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 09.03.2021.
//

import Foundation

/// GET_TRANS_DETAILS Service for the *EdfaPgGetTransactionDetailsAdapter*.
/// 
/// See *EdfaPgGetTransactionDetailsResponse*
///
/// Gets all history of transactions by the order.
public struct EdfaPgGetTransactionDetailsService: XWWWFormUrlEncodable {
    let action = EdfaPgAction.getTransDetails
    let clientKey = EdfaPgSdk.shared.credentials.clientKey
    let transactionId: String
    let hash: String
}

extension EdfaPgGetTransactionDetailsService: Encodable {
    enum CodingKeys: String, CodingKey {
        case hash, action
        case clientKey = "client_key"
        case transactionId = "trans_id"
    }
}
