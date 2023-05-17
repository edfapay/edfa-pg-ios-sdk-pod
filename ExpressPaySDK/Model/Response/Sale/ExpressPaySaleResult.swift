//
//  ExpressPaySaleResult.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 09.03.2021.
//

import Foundation

/// The callback of the *ExpressPaySaleAdapter*.
/// See *ExpressPayCallback*
public typealias ExpressPaySaleCallback = ExpressPayCallback<ExpressPaySaleResult>

/// The result of the *ExpressPaySaleAdapter*.
public enum ExpressPaySaleResult: Decodable {
    
    /// Success result.
    case success(ExpressPaySaleSuccess)
    
    /// Decline result.
    case decline(ExpressPaySaleDecline)
    
    /// Recurring Init result.
    case recurring(ExpressPaySaleRecurring)
    
    /// 3DS result.
    case secure3d(ExpressPaySale3ds)
    
    /// Redirect  result.
    case redirect(ExpressPaySaleRedirect)
    
    /// Actual value: *ExpressPaySaleSuccess* or *ExpressPaySaleDecline* or *ExpressPaySaleRecurring* or *ExpressPaySale3ds*
    public var result: DetailsExpressPayResultProtocol {
        switch self {
        case .success(let result): return result
        case .redirect(let result): return result
        case .decline(let result): return result
        case .recurring(let result): return result
        case .secure3d(let result): return result
        }
    }
    
    public init(from decoder: Decoder) throws {
        self = try ExpressPaySaleDeserializer().decode(from: decoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case success
        case decline
        case recurring
        case secure3d
        case redirect
    }
}
