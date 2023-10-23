//
//  OrderEdfaPgResult.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 08.03.2021.
//

import Foundation

/// The base response order result data holder description.
///
/// See *EdfaPgResponse, EdfaPgResultProtocol*
public protocol OrderEdfaPgResultProtocol: EdfaPgResultProtocol {
    
    /// Amount of capture.
    var orderAmount: Double { get }
    
    /// Currency.
    var orderCurrency: String { get }
}
