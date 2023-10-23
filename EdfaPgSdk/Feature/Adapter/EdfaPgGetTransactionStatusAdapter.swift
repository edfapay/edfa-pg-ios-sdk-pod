//
//  EdfaPgGetTransactionStatusAdapter.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 15.02.2021.
//

import Foundation

/// The API Adapter for the GET_TRANS_STATUS operation.
///
/// See *EdfaPgGetTransactionStatusService*
///
/// See *EdfaPgGetTransactionStatusCallback*
public final class EdfaPgGetTransactionStatusAdapter: EdfaPgBaseAdapter<EdfaPgGetTransactionStatusService> {
    
    /// Executes the *EdfaPgGetTransactionStatusService.getTransactionStatus* request.
    /// - Parameters:
    ///   - transactionId: transaction ID in the Payment Platform. UUID format value.
    ///   - payerEmail: customer’s email. String up to 256 characters.
    ///   - cardNumber: the credit card number.
    ///   - callback: the *EdfaPgGetTransactionStatusCallback*.
    /// - Returns: the *URLSessionDataTask*
    @discardableResult
    public func execute(transactionId: String,
                        payerEmail: String,
                        cardNumber: String,
                        callback: @escaping EdfaPgGetTransactionStatusCallback) -> URLSessionDataTask {
        let hash = EdfaPgHashUtil.hash(email: payerEmail,
                                          cardNumber: cardNumber,
                                          transactionId: transactionId)!
        
        return execute(transactionId: transactionId,
                       hash: hash,
                       callback: callback)
    }
    
    /// Executes the *EdfaPgGetTransactionStatusService.getTransactionStatus* request.
    /// - Parameters:
    ///   - transactionId: transaction ID in the Payment Platform. UUID format value.
    ///   - hash: special signature to validate your request to payment platform.
    ///   - callback: the *EdfaPgGetTransactionStatusCallback*.
    /// - Returns: the *URLSessionDataTask*
    @discardableResult
    public func execute(transactionId: String,
                        hash: String,
                        callback: @escaping EdfaPgGetTransactionStatusCallback) -> URLSessionDataTask {
        procesedRequest(action: .getTransStatus,
                        params: .init(transactionId: transactionId,
                                      hash: hash),
                        callback: callback)
    }
}
