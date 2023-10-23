//
//  EdfaPgRecurringSaleService.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 09.03.2021.
//

import Foundation

/// RECURRING_SALE Service for the *EdfaPgRecurringSaleAdapter*.
/// 
/// See *EdfaPgSaleResponse*
///
/// Recurring payments are commonly used to create new transactions based on already stored cardholder information from
/// previous operations. RECURRING_SALE request has same logic as SALE request, the only difference is that you need to
/// provide primary transaction id, and this request will create a secondary transaction with previously used cardholder
/// data from primary transaction.
public struct EdfaPgRecurringSaleService: XWWWFormUrlEncodable {
    let action = EdfaPgAction.recurringSale
    let clientKey = EdfaPgSdk.shared.credentials.clientKey
    let orderId: String
    let orderAmount: String?
    let orderDescription: String
    let recurringFirstTransactionId: String
    let recurringToken: String
    let auth: EdfaPgOption?
    let hash: String
}

extension EdfaPgRecurringSaleService: Encodable {
    enum CodingKeys: String, CodingKey {
        case auth, hash, action
        case clientKey = "client_key"
        case orderId = "order_id"
        case orderAmount = "order_amount"
        case orderDescription = "order_description"
        case recurringFirstTransactionId = "recurring_first_trans_id"
        case recurringToken = "recurring_token"
    }
}
 
