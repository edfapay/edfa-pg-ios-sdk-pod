//
//  EdfaPgRecurringSaleAdapter.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 15.02.2021.
//

import Foundation

/// The API Adapter for the RECURRING_SALE operation.
///
/// See *EdfaPgRecurringSaleService*
///
/// See *EdfaPgSaleCallback*
public final class EdfaPgRecurringSaleAdapter: EdfaPgBaseAdapter<EdfaPgRecurringSaleService> {
    
    private let amountFormatter = EdfaPgAmountFormatter()
    
    /// Executes the *EdfaPgRecurringSaleService.recurringSale* request.
    /// - Parameters:
    ///   - order: the *EdfaPgOrder*.
    ///   - options: the *EdfaPgRecurringOptions*.
    ///   - payerEmail: customer’s email. String up to 256 characters.
    ///   - cardNumber: the credit card number.
    ///   - auth: indicates that transaction must be only authenticated, but not captured.
    ///   - callback: the *EdfaPgSaleCallback*.
    /// - Returns: the *URLSessionDataTask*
    @discardableResult
    public func execute(order: EdfaPgOrderProtocol,
                        options: EdfaPgRecurringOptions,
                        payerEmail: String,
                        cardNumber: String,
                        auth: Bool,
                        callback: @escaping EdfaPgSaleCallback) -> URLSessionDataTask {
        let hash = EdfaPgHashUtil.hash(email: payerEmail,
                                          cardNumber: cardNumber)!
        
        return execute(order: order,
                       options: options,
                       hash: hash,
                       auth: auth,
                       callback: callback)
    }
    
    /// Executes the *EdfaPgRecurringSaleService.recurringSale* request.
    /// - Parameters:
    ///   - order: the *EdfaPgOrder*.
    ///   - options: the *EdfaPgRecurringOptions*.
    ///   - hash: special signature to validate your request to payment platform.
    ///   - auth: indicates that transaction must be only authenticated, but not captured.
    ///   - callback: the *EdfaPgSaleCallback*.
    /// - Returns: the *URLSessionDataTask*
    @discardableResult
    public func execute(order: EdfaPgOrderProtocol,
                        options: EdfaPgRecurringOptions,
                        hash: String,
                        auth: Bool,
                        callback: @escaping EdfaPgSaleCallback) -> URLSessionDataTask {
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

