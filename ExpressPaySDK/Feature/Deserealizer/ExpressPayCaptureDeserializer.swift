//
//  ExpressPayCaptureDeserializer.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 11.03.2021.
//

import Foundation

final class ExpressPayCaptureDeserializer {
    enum CodingKeys: String, CodingKey {
        case result
    }

    func decode(from decoder: Decoder) throws -> ExpressPayCaptureResult {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let result = try container.decode(ExpressPayResult.self, forKey: .result)
        
        switch result {
        case .declined: return .decline(try .init(from: decoder))
        default: return .success(try .init(from: decoder))
        }
    }
}
