//
//  ExpressPayOrderProtocol.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 29.03.2021.
//

import Foundation

/// The base order data holder description.
///
/// See *ExpressPaySaleAdapter*
public protocol ExpressPayOrderProtocol {
    
    /// Transaction ID in the Merchants system. String up to 255 characters.
    var id: String { get set }
    
    /// The amount of the transaction. Numbers in the form XXXX.XX (without leading zeros).
    var amount: Double { get set }

    /// Description of the transaction (product name). String up to 1024 characters.
    var description: String { get set }
}
