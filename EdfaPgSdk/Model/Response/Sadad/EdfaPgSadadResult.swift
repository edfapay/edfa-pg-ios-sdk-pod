//
//  EdfaPgSadadResult.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 26.12.2025.
//

import Foundation

/// The callback of the *EdfaPgSadadAdapter*.
///
/// See *EdfaPgCallback*
public typealias EdfaPgSadadCallback = EdfaPgCallback<EdfaPgSadadResult>

/// The result of the *EdfaPgSadadAdapter*.
public enum EdfaPgSadadResult: Decodable {
    /// Success result.
    case success(EdfaPgSadadSuccess)
    /// Actual value: *EdfaPgSadadSuccess*
    public var result: EdfaPgSadadSuccess {
        switch self {
        case .success(let result): return result
        }
    }
    public init(from decoder: Decoder) throws {
        self = try EdfaPgSadadDeserializer().decode(from: decoder)
    }
}
