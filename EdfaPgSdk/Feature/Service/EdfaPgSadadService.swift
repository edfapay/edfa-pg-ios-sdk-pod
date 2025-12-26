//
//  EdfaPgSadadService.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 26.12.2025.
//

import Foundation

/// SADAD Service for the *EdfaPgSadadAdapter*.
/// 
/// See *EdfaPgSadadResponse*
///
/// Gets Sadad order status from Payment Platform.
public struct EdfaPgSadadService: JSONBodyEncodable {
    let orderId: String
    let orderAmount: Double
    let orderDescription: String
    let customerName: String
    let mobileNumber: String
    let edfapayMerchantId: String = "c8dbe0e4-f5c3-4596-9c90-19b44a44109b"

}

extension EdfaPgSadadService: Codable {
    enum CodingKeys: String, CodingKey {
        case orderId
        case orderAmount
        case orderDescription
        case customerName
        case mobileNumber
    }
}

