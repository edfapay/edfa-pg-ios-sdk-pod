//
//  ExpressPaySale3ds.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 09.03.2021.
//

import Foundation

/// The SALE 3DS result of the *ExpressPaySaleResult*.
///
/// See *ExpressPaySaleResponse*
public struct ExpressPaySale3ds: DetailsExpressPayResultProtocol {
    
    public let action: ExpressPayAction
    
    public let result: ExpressPayResult
    
    public let status: ExpressPayStatus
    
    public let orderId: String
    
    public let transactionId: String
    
    public let transactionDate: Date
    
    public let descriptor: String?
    
    public let orderAmount: Double
    
    public let orderCurrency: String
    
    /// URL to which the Merchant should redirect the Customer.
    public let redirectUrl: String
    
    /// The *ExpressPaySaleRedirectParams*.
    public let redirectParams: ExpressPaySaleRedirectParams
    
    /// The method of transferring parameters (POST/GET).
    public let redirectMethod: ExpressPayRedirectMethod
}

extension ExpressPaySale3ds: Codable {
    enum CodingKeys: String, CodingKey {
        case action, result, status, descriptor
        case orderId = "order_id"
        case transactionId = "trans_id"
        case transactionDate = "trans_date"
        case orderAmount = "amount"
        case orderCurrency = "currency"
        case redirectUrl = "redirect_url"
        case redirectParams = "redirect_params"
        case redirectMethod = "redirect_method"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        action = try container.decode(ExpressPayAction.self, forKey: .action)
        result = try container.decode(ExpressPayResult.self, forKey: .result)
        status = try container.decode(ExpressPayStatus.self, forKey: .status)
        orderId = try container.decode(String.self, forKey: .orderId)
        transactionId = try container.decode(String.self, forKey: .transactionId)
        orderCurrency = try container.decode(String.self, forKey: .orderCurrency)
        redirectUrl = try container.decode(String.self, forKey: .redirectUrl)
        redirectParams = try container.decode(ExpressPaySaleRedirectParams.self, forKey: .redirectParams)
        redirectMethod = try container.decode(ExpressPayRedirectMethod.self, forKey: .redirectMethod)
        
        orderAmount = Double(try container.decode(String.self, forKey: .orderAmount)) ?? 0
        transactionDate = ExpressPayDateFormatter.date(from: try container.decode(String.self, forKey: .transactionDate)) ?? Date()

        descriptor = try container.decodeIfPresent(String.self, forKey: .descriptor)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = try encoder.container(keyedBy: CodingKeys.self)
        try container.encode(action, forKey: .action)
        try container.encode(status, forKey: .status)
        try container.encode(result, forKey: .result)
        try container.encode(orderId, forKey: .orderId)
        try container.encode(transactionId, forKey: .transactionId)
        try container.encode(orderCurrency, forKey: .orderCurrency)
        try container.encode(redirectUrl, forKey: .redirectUrl)
        try container.encode(redirectParams, forKey: .redirectParams)
        try container.encode(redirectMethod, forKey: .redirectMethod)
        
        try container.encode(orderAmount, forKey: .orderAmount)
        try container.encode(ExpressPayDateFormatter.string(from: transactionDate), forKey: .transactionDate)
        
        try container.encode(descriptor, forKey: .descriptor)

    }
}
