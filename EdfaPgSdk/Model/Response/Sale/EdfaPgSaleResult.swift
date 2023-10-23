//
//  EdfaPgSaleResult.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 09.03.2021.
//

import Foundation

/// The callback of the *EdfaPgSaleAdapter*.
/// See *EdfaPgCallback*
public typealias EdfaPgSaleCallback = EdfaPgCallback<EdfaPgSaleResult>

/// The result of the *EdfaPgSaleAdapter*.
public enum EdfaPgSaleResult: Decodable {
    
    /// Success result.
    case success(EdfaPgSaleSuccess)
    
    /// Decline result.
    case decline(EdfaPgSaleDecline)
    
    /// Recurring Init result.
    case recurring(EdfaPgSaleRecurring)
    
    /// 3DS result.
    case secure3d(EdfaPgSale3ds)
    
    /// Redirect  result.
    case redirect(EdfaPgSaleRedirect)
    
    /// Actual value: *EdfaPgSaleSuccess* or *EdfaPgSaleDecline* or *EdfaPgSaleRecurring* or *EdfaPgSale3ds*
    public var result: DetailsEdfaPgResultProtocol {
        switch self {
        case .success(let result): return result
        case .redirect(let result): return result
        case .decline(let result): return result
        case .recurring(let result): return result
        case .secure3d(let result): return result
        }
    }
    
    public init(from decoder: Decoder) throws {
        self = try EdfaPgSaleDeserializer().decode(from: decoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case success
        case decline
        case recurring
        case secure3d
        case redirect
    }
}
