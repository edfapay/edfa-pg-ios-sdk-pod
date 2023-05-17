//
//  ExpressPayCredential.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 15.02.2021.
//

import Foundation

/// Class which holds all ExpressPay credentials which was passed from *ExpressPaySdk.config(...)* methods
public struct ExpressPayCredential {
    
    /// Unique key to identify the account in Payment ExpressPay (used as request parameter)
    public let clientKey: String
    
    /// Password for Client authentication in Payment ExpressPay (used for calculating hash parameter)
    public let clientPass: String
    
    /// URL to request the Payment ExpressPay
    public let paymentUrl: String
    
    /// Provide ExpressPay SDK credentials and store them here
    /// - Parameters:
    ///   - clientKey: Unique key to identify the account in Payment ExpressPay (used as request parameter)
    ///   - clientPass: Password for Client authentication in Payment ExpressPay (used for calculating hash parameter)
    ///   - paymentUrl: URL to request the Payment ExpressPay
    public init(clientKey: String, clientPass: String, paymentUrl: String) {
        self.clientKey = clientKey
        self.clientPass = clientPass
        self.paymentUrl = paymentUrl
    }
}
