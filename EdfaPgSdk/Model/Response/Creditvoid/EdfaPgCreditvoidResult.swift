//
//  EdfaPgCreditvoidResult.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 09.03.2021.
//

import Foundation

/// The callback of the *EdfaPgCreditvoidAdapter*.
///
/// See *EdfaPgCallback*
public typealias EdfaPgCreditvoidCallback = EdfaPgCallback<EdfaPgCreditvoidResult>

/// The result of the*EdfaPgCreditvoidAdapter*.
public enum EdfaPgCreditvoidResult: Decodable {
    
    /// Success result.
    case success(EdfaPgCreditvoidSuccess)
    
    /// Actual value: *EdfaPgCreditvoidSuccess*.
    public var result: EdfaPgResultProtocol {
        switch self {
        case .success(let result): return result
        }
    }
    
    public init(from decoder: Decoder) throws {
        self = try EdfaPgCreditvoidDeserializer().decode(from: decoder)
    }
}
