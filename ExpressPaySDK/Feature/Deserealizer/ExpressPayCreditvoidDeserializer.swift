//
//  ExpressPayCreditvoidDeserializer.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 11.03.2021.
//

import Foundation

final class ExpressPayCreditvoidDeserializer {
    func decode(from decoder: Decoder) throws -> ExpressPayCreditvoidResult {
        return try .success(.init(from: decoder))
    }
}
