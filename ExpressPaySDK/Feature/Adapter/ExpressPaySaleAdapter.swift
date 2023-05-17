//
//  ExpressPaySaleAdapter.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 15.02.2021.
//

import Foundation

/// The API Adapter for the SALE operation.
///
/// See *ExpressPaySaleService*
///
/// See *ExpressPaySaleCallback*
///
/// See *ExpressPaySaleResponse*
public final class ExpressPaySaleAdapter: ExpressPayBaseAdapter<ExpressPaySaleService> {
    
    private let amountFormatter = ExpressPayAmountFormatter()
    private let cardFormatter = ExpressPayCardFormatter()
    private let payerOptionsFormatter = ExpressPayPayerOptionsFormatter()
    
    /// Executes the *ExpressPaySaleService.sale* request.
    /// - Parameters:
    ///   - order: the *ExpressPaySaleOrder*.
    ///   - card: the *ExpressPayCard*.
    ///   - payer: the *ExpressPayPayer*.
    ///   - termUrl3ds: URL to which Customer should be returned after 3D-Secure. String up to 1024 characters.
    ///   - options: the *ExpressPaySaleOptions*. Optional.
    ///   - auth: indicates that transaction must be only authenticated, but not captured.
    ///   - callback: the *ExpressPaySaleCallback*.
    /// - Returns: the *URLSessionDataTask*
    @discardableResult
    public func execute(order: ExpressPaySaleOrder,
                        card: ExpressPayCard,
                        payer: ExpressPayPayer,
                        termUrl3ds: String,
                        options: ExpressPaySaleOptions? = nil,
                        auth: Bool,
                        callback: @escaping ExpressPaySaleCallback) -> URLSessionDataTask {
        let hash = ExpressPayHashUtil.hash(email: payer.email,
                                          cardNumber: card.number)!
        let payerOptions = payer.options
        
        return procesedRequest(action: .sale,
                               params: .init(channelId: options?.channelId,
                                             orderId: order.id,
                                             orderAmount: amountFormatter.amountFormat(for: order.amount) ?? "",
                                             orderCurrency: order.currency,
                                             orderDescription: order.description,
                                             cardNumber: card.number,
                                             cardExpireMonth: cardFormatter.expireMonthFormat(for: card) ?? "",
                                             cardExpireYear: cardFormatter.expireYearFormat(for: card) ?? "",
                                             cardCvv2: card.cvv,
                                             payerFirstName: payer.firstName,
                                             payerLastName: payer.lastName,
                                             payerMiddleName: payerOptions?.middleName,
                                             payerBirthDate: payerOptionsFormatter.birthdateFormat(payerOptions: payerOptions),
                                             payerAddress: payer.address,
                                             payerAddress2: payerOptions?.address2,
                                             payerCountry: payer.country,
                                             payerState: payerOptions?.state,
                                             payerCity: payer.city,
                                             payerZip: payer.zip,
                                             payerEmail: payer.email,
                                             payerPhone: payer.phone,
                                             payerIp: payer.ip,
                                             termUrl3ds: termUrl3ds,
                                             recurringInit: ExpressPayOption(options?.recurringInit ?? false),
                                             auth: ExpressPayOption(auth),
                                             hash: hash),
                               callback: callback)
    }
}
