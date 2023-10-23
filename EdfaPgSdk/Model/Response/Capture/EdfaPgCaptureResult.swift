//
//  EdfaPgCaptureResult.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 08.03.2021.
//

import Foundation

/// The callback of the *EdfaPgCaptureAdapter*.
///
/// See *EdfaPgCallback*
public typealias EdfaPgCaptureCallback = EdfaPgCallback<EdfaPgCaptureResult>

/// The result of the *EdfaPgCaptureAdapter*.
public enum EdfaPgCaptureResult: Decodable {
    
    /// Success result.
    case success(EdfaPgCaptureSuccess)
    
    /// Decline result.
    case decline(EdfaPgSaleDecline)
    
    /// Actual result value: *EdfaPgCaptureSuccess* or *EdfaPgSaleDecline*
    public var result: DetailsEdfaPgResultProtocol {
        switch self {
        case .success(let result): return result
        case .decline(let result): return result
        }
    }
    
    public init(from decoder: Decoder) throws {
        self = try EdfaPgCaptureDeserializer().decode(from: decoder)
    }
}
