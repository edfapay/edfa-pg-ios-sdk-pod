//
//  EdfaPgGetTransactionStatusService.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 09.03.2021.
//

import Foundation

/// GET_TRANS_STATUS Service for the *EdfaPgGetTransactionStatusAdapter*.
/// 
/// See *EdfaPgGetTransactionStatusResponse*
///
/// Gets order status from Payment Platform.
public struct EdfaPgGetTransactionStatusService: XWWWFormUrlEncodable {
    let action = EdfaPgAction.getTransStatus
    let clientKey = EdfaPgSdk.shared.credentials.clientKey
    let transactionId: String
    let hash: String
}

extension EdfaPgGetTransactionStatusService: Encodable {
    enum CodingKeys: String, CodingKey {
        case hash, action
        case clientKey = "client_key"
        case transactionId = "trans_id"
    }
}
