//
//  EdfaPgGetTransactionStatusDeserializer.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 11.03.2021.
//

import Foundation

final class EdfaPgGetTransactionStatusDeserializer {
    func decode(from decoder: Decoder) throws -> EdfaPgGetTransactionStatusResult {
        return try .success(.init(from: decoder))
    }
}
