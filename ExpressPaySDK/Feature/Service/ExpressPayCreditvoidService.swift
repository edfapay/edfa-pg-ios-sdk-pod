//
//  ExpressPayCreditvoidService.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 09.03.2021.
//

import Foundation

/// CREDITVOID Service for the *ExpressPayCreditvoidAdapter*.
/// 
/// See *ExpressPayCreditvoidResponse*
///
/// CREDITVOID request is used to complete both REFUND and REVERSAL transactions.
///
/// REVERSAL transaction is used to cancel hold from funds on card account, previously authorized by AUTH transaction.
///
/// REFUND transaction is used to return funds to card account, previously submitted by SALE or CAPTURE transactions.
public struct ExpressPayCreditvoidService: XWWWFormUrlEncodable {
    let action = ExpressPayAction.creditvoid
    let clientKey = ExpressPaySDK.shared.credentials.clientKey
    let transactionId: String
    let amount: String?
    let hash: String
}

extension ExpressPayCreditvoidService: Encodable {
    enum CodingKeys: String, CodingKey {
        case amount, hash, action
        case clientKey = "client_key"
        case transactionId = "trans_id"
    }
}

