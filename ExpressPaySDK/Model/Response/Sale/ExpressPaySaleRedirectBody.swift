//
//  ExpressPaySaleRedirectPostParams.swift
//  ExpressPaySDK
//
//  Created by Zohaib Kambrani on 22/01/2023.
//

import Foundation


public struct ExpressPaySaleRedirectBody{
    public let body: String?
}

extension ExpressPaySaleRedirectBody: Codable {
    enum CodingKeys: String, CodingKey {
        case body
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        body = try container.decode(String.self, forKey: .body)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = try encoder.container(keyedBy: CodingKeys.self)
        try container.encode(body, forKey: .body)
        
    }
}
