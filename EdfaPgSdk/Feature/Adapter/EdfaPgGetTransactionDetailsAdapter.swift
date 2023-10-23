//
//  EdfaPgGetTransactionDetailsAdapter.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 15.02.2021.
//

import Foundation

/// The API Adapter for the GET_TRANS_DETAILS operation.
///
/// See *EdfaPgGetTransactionDetailsService*
///
/// See *EdfaPgGetTransactionDetailsCallback*
public final class EdfaPgGetTransactionDetailsAdapter: EdfaPgBaseAdapter<EdfaPgGetTransactionDetailsService> {
    
    /// Executes the *fEdfaPgGetTransactionDetailsService.getTransactionDetails* request.
    /// - Parameters:
    ///   - transactionId: transaction ID in the Payment Platform. UUID format value.
    ///   - payerEmail: customer’s email. String up to 256 characters.
    ///   - cardNumber: the credit card number.
    ///   - callback: the *EdfaPgGetTransactionDetailsCallback*.
    /// - Returns: the *URLSessionDataTask*
    @discardableResult
    public func execute(transactionId: String,
                        payerEmail: String,
                        cardNumber: String,
                        callback: @escaping EdfaPgGetTransactionDetailsCallback) -> URLSessionDataTask {
        let hash = EdfaPgHashUtil.hash(email: payerEmail,
                                          cardNumber: cardNumber,
                                          transactionId: transactionId)!
        
        return execute(transactionId: transactionId,
                       hash: hash,
                       callback: callback)
    }
    
    /// Executes the *EdfaPgGetTransactionDetailsService.getTransactionDetails* request.
    /// - Parameters:
    ///   - transactionId: transaction ID in the Payment Platform. UUID format value.
    ///   - hash: special signature to validate your request to payment platform.
    ///   - callback: the *EdfaPgGetTransactionDetailsCallback*.
    /// - Returns: the *URLSessionDataTask*
    @discardableResult
    public func execute(transactionId: String,
                        hash: String,
                        callback: @escaping EdfaPgGetTransactionDetailsCallback) -> URLSessionDataTask {
        procesedRequest(action: .getTransDetails,
                        params: .init(transactionId: transactionId,
                                      hash: hash),
                        callback: callback)
    }
}


