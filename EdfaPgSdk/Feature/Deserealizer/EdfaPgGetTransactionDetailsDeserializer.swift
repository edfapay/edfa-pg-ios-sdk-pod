//
//  EdfaPgGetTransactionDetailsDeserializer.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 11.03.2021.
//

import Foundation

final class EdfaPgGetTransactionDetailsDeserializer {
    func decode(from decoder: Decoder) throws -> EdfaPgGetTransactionDetailsResult {
        return try .success(.init(from: decoder))
    }
}
