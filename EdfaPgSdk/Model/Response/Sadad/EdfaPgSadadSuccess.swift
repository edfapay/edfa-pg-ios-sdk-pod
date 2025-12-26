//
//  EdfaPgSadadSuccess.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 26.12.2025.
//

import Foundation

/// The SADAD success result of the *EdfaPgSadadResult*.
///
/// See *EdfaPgSadadResponse*
public struct EdfaPgSadadSuccess{
    public let  billNumber: String
    public let sadadNumber: String
}

extension EdfaPgSadadSuccess: Codable {
    enum CodingKeys: String, CodingKey {
        case billNumber, sadadNumber
    }
}
