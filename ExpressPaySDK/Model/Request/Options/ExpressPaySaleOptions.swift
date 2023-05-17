//
//  ExpressPaySaleOptions.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 15.02.2021.
//

import Foundation

/// The optional sale options for the *ExpressPaySaleAdapter*.
///
/// See *ExpressPayRecurringSaleAdapter*
public final class ExpressPaySaleOptions {
    
    /// Payment channel (Sub-account). String up to 16 characters.
    public var channelId: String?
    
    /// Initialization of the transaction with possible following recurring.
    public var recurringInit: Bool?
    
    /// Create the optional sale options for the *ExpressPaySaleAdapter*.
    /// - Parameters:
    ///   - channelId: Payment channel (Sub-account). String up to 16 characters.
    ///   - recurringInit: Initialization of the transaction with possible following recurring.
    public init(channelId: String?, recurringInit: Bool?) {
        self.channelId = channelId
        self.recurringInit = recurringInit
    }
}
