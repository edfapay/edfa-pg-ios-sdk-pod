//
//  ExpressPayAmountFormatter.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 09.03.2021.
//

import Foundation

/// The amount values formatter. All amount value should be in the format: XXXX.XX (without leading zeros).
final class ExpressPayAmountFormatter {
    
    private let formatter = NumberFormatter()
    
    init() {
        formatter.usesGroupingSeparator = false
        
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        formatter.minimumIntegerDigits = 1
    }
    
    /// Validate and format the amount value.
    /// - Parameter amount: the double value.
    /// - Returns: Formated amount value in string format
    func amountFormat(for amount: Double?) -> String? {
        guard let amount = amount else { return nil }
        
        return formatter.string(from: NSNumber(value: amount))
    }
}
