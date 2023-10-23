//
//  EdfaPgCreditvoidDeserializer.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 11.03.2021.
//

import Foundation

final class EdfaPgCreditvoidDeserializer {
    func decode(from decoder: Decoder) throws -> EdfaPgCreditvoidResult {
        return try .success(.init(from: decoder))
    }
}
