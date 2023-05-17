//
//  ExpressPayAdapterFactory.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 28.03.2021.
//

import Foundation

/// Factory class which helps to create adapters
public final class ExpressPayAdapterFactory {
    
    public init() { }
    
    /// Create and return *ExpressPaySaleAdapter*
    /// - Returns: ExpressPaySaleAdapter
    public func createSale() -> ExpressPaySaleAdapter {
        ExpressPaySaleAdapter()
    }
    
    /// Create and return *ExpressPayRecurringSaleAdapter*
    /// - Returns: ExpressPayRecurringSaleAdapter
    public func createRecurringSale() -> ExpressPayRecurringSaleAdapter {
        ExpressPayRecurringSaleAdapter()
    }
    
    /// Create and return *ExpressPayCaptureAdapter*
    /// - Returns: ExpressPayCaptureAdapter
    public func createCapture() -> ExpressPayCaptureAdapter {
        ExpressPayCaptureAdapter()
    }
    
    /// Create and return *ExpressPayCreditvoidAdapter*
    /// - Returns: ExpressPayCreditvoidAdapter
    public func createCreditvoid() -> ExpressPayCreditvoidAdapter {
        ExpressPayCreditvoidAdapter()
    }
    
    /// Create and return *ExpressPayGetTransactionStatusAdapter*
    /// - Returns: ExpressPayGetTransactionStatusAdapter
    public func createGetTransactionStatus() -> ExpressPayGetTransactionStatusAdapter {
        ExpressPayGetTransactionStatusAdapter()
    }
    
    /// Create and return *ExpressPayGetTransactionDetailsAdapter*
    /// - Returns: ExpressPayGetTransactionDetailsAdapter
    public func createGetTransactionDetails() -> ExpressPayGetTransactionDetailsAdapter {
        ExpressPayGetTransactionDetailsAdapter()
    }
}
