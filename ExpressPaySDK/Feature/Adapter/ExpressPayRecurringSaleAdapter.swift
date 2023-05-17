//
//  ExpressPayRecurringSaleAdapter.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 15.02.2021.
//

import Foundation

/// The API Adapter for the RECURRING_SALE operation.
///
/// See *ExpressPayRecurringSaleService*
///
/// See *ExpressPaySaleCallback*
public final class ExpressPayRecurringSaleAdapter: ExpressPayBaseAdapter<ExpressPayRecurringSaleService> {
    
    private let amountFormatter = ExpressPayAmountFormatter()
    
    /// Executes the *ExpressPayRecurringSaleService.recurringSale* request.
    /// - Parameters:
    ///   - order: the *ExpressPayOrder*.
    ///   - options: the *ExpressPayRecurringOptions*.
    ///   - payerEmail: customer’s email. String up to 256 characters.
    ///   - cardNumber: the credit card number.
    ///   - auth: indicates that transaction must be only authenticated, but not captured.
    ///   - callback: the *ExpressPaySaleCallback*.
    /// - Returns: the *URLSessionDataTask*
    @discardableResult
    public func execute(order: ExpressPayOrderProtocol,
                        options: ExpressPayRecurringOptions,
                        payerEmail: String,
                        cardNumber: String,
                        auth: Bool,
                        callback: @escaping ExpressPaySaleCallback) -> URLSessionDataTask {
        let hash = ExpressPayHashUtil.hash(email: payerEmail,
                                          cardNumber: cardNumber)!
        
        return execute(order: order,
                       options: options,
                       hash: hash,
                       auth: auth,
                       callback: callback)
    }
    
    /// Executes the *ExpressPayRecurringSaleService.recurringSale* request.
    /// - Parameters:
    ///   - order: the *ExpressPayOrder*.
    ///   - options: the *ExpressPayRecurringOptions*.
    ///   - hash: special signature to validate your request to payment platform.
    ///   - auth: indicates that transaction must be only authenticated, but not captured.
    ///   - callback: the *ExpressPaySaleCallback*.
    /// - Returns: the *URLSessionDataTask*
    @discardableResult
    public func execute(order: ExpressPayOrderProtocol,
                        options: ExpressPayRecurringOptions,
                        hash: String,
                        auth: Bool,
                        callback: @escaping ExpressPaySaleCallback) -> URLSessionDataTask {
        procesedRequest(action: .recurringSale,
                        params: .init(orderId: order.id,
                                      orderAmount: amountFormatter.amountFormat(for: order.amount) ?? "",
                                      orderDescription: order.description,
                                      recurringFirstTransactionId: options.firstTransactionId,
                                      recurringToken: options.token,
                                      auth: .init(auth),
                                      hash: hash),
                        callback: callback)
    }
}

