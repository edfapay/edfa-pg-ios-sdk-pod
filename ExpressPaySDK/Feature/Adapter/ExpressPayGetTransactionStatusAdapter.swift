//
//  ExpressPayGetTransactionStatusAdapter.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 15.02.2021.
//

import Foundation

/// The API Adapter for the GET_TRANS_STATUS operation.
///
/// See *ExpressPayGetTransactionStatusService*
///
/// See *ExpressPayGetTransactionStatusCallback*
public final class ExpressPayGetTransactionStatusAdapter: ExpressPayBaseAdapter<ExpressPayGetTransactionStatusService> {
    
    /// Executes the *ExpressPayGetTransactionStatusService.getTransactionStatus* request.
    /// - Parameters:
    ///   - transactionId: transaction ID in the Payment Platform. UUID format value.
    ///   - payerEmail: customer’s email. String up to 256 characters.
    ///   - cardNumber: the credit card number.
    ///   - callback: the *ExpressPayGetTransactionStatusCallback*.
    /// - Returns: the *URLSessionDataTask*
    @discardableResult
    public func execute(transactionId: String,
                        payerEmail: String,
                        cardNumber: String,
                        callback: @escaping ExpressPayGetTransactionStatusCallback) -> URLSessionDataTask {
        let hash = ExpressPayHashUtil.hash(email: payerEmail,
                                          cardNumber: cardNumber,
                                          transactionId: transactionId)!
        
        return execute(transactionId: transactionId,
                       hash: hash,
                       callback: callback)
    }
    
    /// Executes the *ExpressPayGetTransactionStatusService.getTransactionStatus* request.
    /// - Parameters:
    ///   - transactionId: transaction ID in the Payment Platform. UUID format value.
    ///   - hash: special signature to validate your request to payment platform.
    ///   - callback: the *ExpressPayGetTransactionStatusCallback*.
    /// - Returns: the *URLSessionDataTask*
    @discardableResult
    public func execute(transactionId: String,
                        hash: String,
                        callback: @escaping ExpressPayGetTransactionStatusCallback) -> URLSessionDataTask {
        procesedRequest(action: .getTransStatus,
                        params: .init(transactionId: transactionId,
                                      hash: hash),
                        callback: callback)
    }
}
