//
//  Extensions.swift
//  EdfaPgSdk
//
//  Created by ZIK on 24/02/2024.
//

import Foundation

extension Encodable{
    
    func json() -> [String:Any]{
        guard let data = try? JSONEncoder().encode(self),
              let dict = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any]
        else { return [:] }
        
        return dict
    }
    
}
