//
//  ExpressPayCaptureService.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 09.03.2021.
//

import Foundation

/// CAPTURE Service for the *ExpressPayCaptureAdapter*.
///
/// See *ExpressPayCaptureResponse*
///
/// CAPTURE request is used to submit previously authorized transaction (created by SALE request with parameter auth = Y). Hold funds will be transferred to Merchants account.
public struct ExpressPayCaptureService: XWWWFormUrlEncodable {
    let action = ExpressPayAction.capture
    let clientKey = ExpressPaySDK.shared.credentials.clientKey
    let transactionId: String
    let amount: String?
    let hash: String
}

extension ExpressPayCaptureService: Encodable {
    enum CodingKeys: String, CodingKey {
        case amount, hash, action
        case clientKey = "client_key"
        case transactionId = "trans_id"
    }
}
