//
//  ExpressPaySaleService.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 09.03.2021.
//

import Foundation

/// SALE Service for the *ExpressPaySaleAdapter*.
/// 
/// See *ExpressPaySaleResponse*
///
/// Payment Platform supports two main operation type: Single Message System (SMS) and Dual Message System (DMS).
/// SMS is represented by SALE transaction. It is used for authorization and capture at a time.
///
/// This operation is commonly used for immediate payments. DMS is represented by AUTH and CAPTURE transactions.
/// AUTH  is used for authorization only, without capture. This operation used to hold the funds on card account
/// (for example to check card validity). SALE request is used to make both SALE and AUTH transactions.
///
/// If you want to make AUTH transaction, you need to use parameter auth with value Y.
///
/// If you want to send a payment for the specific sub-account (channel), you need to use channel_id,
/// that specified in your Payment Platform account settings.
public struct ExpressPaySaleService: XWWWFormUrlEncodable {
    let action = ExpressPayAction.sale
    let clientKey = ExpressPaySDK.shared.credentials.clientKey
    let channelId: String?
    let orderId: String
    let orderAmount: String
    let orderCurrency: String
    let orderDescription: String
    let cardNumber: String
    let cardExpireMonth: String
    let cardExpireYear: String
    let cardCvv2: String
    let payerFirstName: String
    let payerLastName: String
    let payerMiddleName: String?
    let payerBirthDate: String?
    let payerAddress: String
    let payerAddress2: String?
    let payerCountry: String
    let payerState: String?
    let payerCity: String
    let payerZip: String
    let payerEmail: String
    let payerPhone: String
    let payerIp: String
    let termUrl3ds: String
    let recurringInit: ExpressPayOption?
    let auth: ExpressPayOption?
    let hash: String
}

extension ExpressPaySaleService: Encodable {
    enum CodingKeys: String, CodingKey {
        case auth, hash, action
        case clientKey = "client_key"
        case channelId = "channel_id"
        case orderId = "order_id"
        case orderAmount = "order_amount"
        case orderCurrency = "order_currency"
        case orderDescription = "order_description"
        case cardNumber = "card_number"
        case cardExpireMonth = "card_exp_month"
        case cardExpireYear = "card_exp_year"
        case cardCvv2 = "card_cvv2"
        case payerFirstName = "payer_first_name"
        case payerLastName = "payer_last_name"
        case payerMiddleName = "payer_middle_name"
        case payerBirthDate = "payer_birth_date"
        case payerAddress = "payer_address"
        case payerAddress2 = "payer_address2"
        case payerCountry = "payer_country"
        case payerState = "payer_state"
        case payerCity = "payer_city"
        case payerZip = "payer_zip"
        case payerEmail = "payer_email"
        case payerPhone = "payer_phone"
        case payerIp = "payer_ip"
        case termUrl3ds = "term_url_3ds"
        case recurringInit = "recurring_init"
    }
}
