//
//  EdfaPgSaleDeserializer.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 11.03.2021.
//

import Foundation

final class EdfaPgSaleDeserializer {
    
    enum CodingKeys: String, CodingKey {
        case status, result
        case recurringToken = "recurring_token"
    }
    
    func decode(from decoder: Decoder) throws -> EdfaPgSaleResult {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let status = try container.decode(EdfaPgStatus.self, forKey: .status)
        let result = try container.decode(EdfaPgResult.self, forKey: .result)
        
        switch status {
        case .secure3D: return .secure3d(try .init(from: decoder))
        case .redirect: return .redirect(try .init(from: decoder))
            
        default:
            switch result {
            case .declined: return .decline(try .init(from: decoder))
            default:
                if container.contains(.recurringToken) {
                    return .recurring(try .init(from: decoder))
                }
                
                return .success(try .init(from: decoder))
            }
        }
    }
}
