//
//  EdfaPgSadadAdapter.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 26.12.2025.
//

import Foundation

/// The API Adapter for the SADAD operation.
///
/// See *EdfaPgSadadService*
///
/// See *EdfaPgSadadCallback*
public final class EdfaPgSadadAdapter: EdfaPgSadadBaseAdapter<EdfaPgSadadService> {
    /// Executes the *EdfaPgSadadService* request.
    /// - Parameters:
    ///   - transactionId: transaction ID in the Payment Platform. UUID format value.
    ///   - payerEmail: customer’s email. String up to 256 characters.
    ///   - cardNumber: the credit card number.
    ///   - callback: the *EdfaPgSadadCallback*.
    /// - Returns: the *URLSessionDataTask*
    @discardableResult
    public func execute(
            orderId: String,
            orderAmount: Double,
            orderDescription: String,
            customerName: String,
            mobileNumber: String,
            callback: @escaping EdfaPgSadadCallback) -> URLSessionDataTask {
                let params = EdfaPgSadadService(
                    orderId: orderId,
                    orderAmount: orderAmount,
                    orderDescription: orderDescription,
                    customerName: customerName,
                    mobileNumber: mobileNumber
                )
                
        return procesedRequest(
            params: params,
            callback: callback
        )
    }
}
