//
//  ExpressPayGetTransactionStatusDeserializer.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 11.03.2021.
//

import Foundation

final class ExpressPayGetTransactionStatusDeserializer {
    func decode(from decoder: Decoder) throws -> ExpressPayGetTransactionStatusResult {
        return try .success(.init(from: decoder))
    }
}
