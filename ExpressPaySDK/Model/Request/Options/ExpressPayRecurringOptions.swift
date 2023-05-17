//
//  ExpressPayRecurringOptions.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 15.02.2021.
//

import Foundation

/// The required recurring options for the *ExpressPayRecurringSaleAdapter*.
///
/// See *ExpressPaySaleAdapter*
public final class ExpressPayRecurringOptions {
    
    /// Transaction ID of the primary transaction in the Payment Platform. UUID format value.
    public var firstTransactionId: String
    
    /// Value obtained during the primary transaction. UUID format value.
    public var token: String
    
    /// Create the required recurring options for the *ExpressPayRecurringSaleAdapter*.
    /// - Parameters:
    ///   - firstTransactionId: Transaction ID of the primary transaction in the Payment Platform. UUID format value.
    ///   - token: Value obtained during the primary transaction. UUID format value.
    public init(firstTransactionId: String, token: String) {
        self.firstTransactionId = firstTransactionId
        self.token = token
    }
}
