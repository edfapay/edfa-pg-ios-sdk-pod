//
//  EdfaPgSaleTransactionVirtualDeserializer.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 11.03.2021.
//

import Foundation

final class EdfaPgSaleTransactionVirtualDeserializer {
    func decode(from decoder: Decoder) throws -> EdfaPgSaleVirtualTransactionResult {
        return try .success(.init(from: decoder))
    }
}
