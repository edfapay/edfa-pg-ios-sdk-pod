//
//  EdfaPgCredential.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 15.02.2021.
//

import Foundation

/// Class which holds all EdfaPg credentials which was passed from *EdfaPgSdk.config(...)* methods
public struct EdfaPgCredential {
    
    /// Unique key to identify the account in Payment EdfaPg (used as request parameter)
    public let clientKey: String
    
    /// Password for Client authentication in Payment EdfaPg (used for calculating hash parameter)
    public let clientPass: String
    
    /// URL to request the Payment EdfaPg
    public let paymentUrl: String
    
    /// Provide EdfaPg SDK credentials and store them here
    /// - Parameters:
    ///   - clientKey: Unique key to identify the account in Payment EdfaPg (used as request parameter)
    ///   - clientPass: Password for Client authentication in Payment EdfaPg (used for calculating hash parameter)
    ///   - paymentUrl: URL to request the Payment EdfaPg
    public init(clientKey: String, clientPass: String, paymentUrl: String) {
        self.clientKey = clientKey
        self.clientPass = clientPass
        self.paymentUrl = paymentUrl
    }
}
