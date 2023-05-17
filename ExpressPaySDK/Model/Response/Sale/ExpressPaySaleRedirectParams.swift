//
//  ExpressPaySaleRedirectParams.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 09.03.2021.
//

import Foundation

/// The 3DS SALE redirect data holder. These values are required to proceed with the 3DSecure Payment flow.
/// 
/// See *ExpressPaySale3ds*
public struct ExpressPaySaleRedirectParams {
    
    /// The PaReq message from the DIBS server response.
    public let paymentRequisites: String
    
    /// (Merchant Data) the reference number for the transaction. This parameter will be included in the
    /// request to the TermUrl so that the merchant will be able to identify the transaction.
    public let md: String?
    
    /// The URL (at the merchant's web site) that the authenticating bank should send the consumer back
    /// to upon completion of the authentication.
    public let termUrl: String
}

extension ExpressPaySaleRedirectParams: Codable {
    enum CodingKeys: String, CodingKey {
        case paymentRequisites = "PaReq"
        case md = "MD"
        case termUrl = "TermUrl"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        paymentRequisites = try container.decode(String.self, forKey: .paymentRequisites)
        termUrl = try container.decode(String.self, forKey: .termUrl)
        md = try container.decodeIfPresent(String.self, forKey: .md)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = try encoder.container(keyedBy: CodingKeys.self)
        try container.encode(paymentRequisites, forKey: .paymentRequisites)
        try container.encode(termUrl, forKey: .termUrl)
        try container.encode(md, forKey: .md)
    }
}
