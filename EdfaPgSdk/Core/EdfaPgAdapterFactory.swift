//
//  EdfaPgAdapterFactory.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 28.03.2021.
//

import Foundation

/// Factory class which helps to create adapters
public final class EdfaPgAdapterFactory {
    
    public init() { }
    
    /// Create and return *EdfaPgSaleAdapter*
    /// - Returns: EdfaPgSaleAdapter
    public func createSale() -> EdfaPgSaleAdapter {
        EdfaPgSaleAdapter()
    }
    
    /// Create and return *EdfaPgRecurringSaleAdapter*
    /// - Returns: EdfaPgRecurringSaleAdapter
    public func createRecurringSale() -> EdfaPgRecurringSaleAdapter {
        EdfaPgRecurringSaleAdapter()
    }
    
    /// Create and return *EdfaPgCaptureAdapter*
    /// - Returns: EdfaPgCaptureAdapter
    public func createCapture() -> EdfaPgCaptureAdapter {
        EdfaPgCaptureAdapter()
    }
    
    /// Create and return *EdfaPgCreditvoidAdapter*
    /// - Returns: EdfaPgCreditvoidAdapter
    public func createCreditvoid() -> EdfaPgCreditvoidAdapter {
        EdfaPgCreditvoidAdapter()
    }
    
    /// Create and return *EdfaPgGetTransactionStatusAdapter*
    /// - Returns: EdfaPgGetTransactionStatusAdapter
    public func createGetTransactionStatus() -> EdfaPgGetTransactionStatusAdapter {
        EdfaPgGetTransactionStatusAdapter()
    }
    
    /// Create and return *EdfaPgGetTransactionDetailsAdapter*
    /// - Returns: EdfaPgGetTransactionDetailsAdapter
    public func createGetTransactionDetails() -> EdfaPgGetTransactionDetailsAdapter {
        EdfaPgGetTransactionDetailsAdapter()
    }
}
