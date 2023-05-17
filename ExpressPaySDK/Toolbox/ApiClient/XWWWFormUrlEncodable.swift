//
//  XWWWFormUrlEncodable.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 11.03.2021.
//

import Foundation

protocol XWWWFormUrlEncodable: Encodable {
    var formUrlEncodableData: Data? { get }
}

extension XWWWFormUrlEncodable {
    var formUrlEncodableData: Data? {
        guard let data = try? JSONEncoder().encode(self),
              let dict = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any]
        else { return nil }
        
        let string = dict.compactMap {
            let value = "\($0.value)"
            
            guard value != "" else { return nil }
            
            return "\($0.key)=\(value)"
        }.joined(separator: "&")
        
        return string.data(using: .ascii, allowLossyConversion: false)
    }
}
