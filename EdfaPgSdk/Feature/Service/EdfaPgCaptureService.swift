//
//  EdfaPgCaptureService.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 09.03.2021.
//

import Foundation

/// CAPTURE Service for the *EdfaPgCaptureAdapter*.
///
/// See *EdfaPgCaptureResponse*
///
/// CAPTURE request is used to submit previously authorized transaction (created by SALE request with parameter auth = Y). Hold funds will be transferred to Merchants account.
public struct EdfaPgCaptureService: XWWWFormUrlEncodable {
    let action = EdfaPgAction.capture
    let clientKey = EdfaPgSdk.shared.credentials.clientKey
    let transactionId: String
    let amount: String?
    let hash: String
}

extension EdfaPgCaptureService: Encodable {
    enum CodingKeys: String, CodingKey {
        case amount, hash, action
        case clientKey = "client_key"
        case transactionId = "trans_id"
    }
}
