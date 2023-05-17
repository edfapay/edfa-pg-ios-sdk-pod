//
//  ExpressPayGetTransactionDetailsDeserializer.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 11.03.2021.
//

import Foundation

final class ExpressPayGetTransactionDetailsDeserializer {
    func decode(from decoder: Decoder) throws -> ExpressPayGetTransactionDetailsResult {
        return try .success(.init(from: decoder))
    }
}
