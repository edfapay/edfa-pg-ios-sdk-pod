//
//  EdfaPgSadadDeserializer.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 26.12.2025.
//

import Foundation

final class EdfaPgSadadDeserializer {
    func decode(from decoder: Decoder) throws -> EdfaPgSadadResult {
        return try .success(.init(from: decoder))
    }
}
