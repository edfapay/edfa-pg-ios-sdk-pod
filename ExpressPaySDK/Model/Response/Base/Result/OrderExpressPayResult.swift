//
//  OrderExpressPayResult.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 08.03.2021.
//

import Foundation

/// The base response order result data holder description.
///
/// See *ExpressPayResponse, ExpressPayResultProtocol*
public protocol OrderExpressPayResultProtocol: ExpressPayResultProtocol {
    
    /// Amount of capture.
    var orderAmount: Double { get }
    
    /// Currency.
    var orderCurrency: String { get }
}
