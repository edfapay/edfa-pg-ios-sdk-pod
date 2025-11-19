//
//  EdfaPgExtensions.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 09.03.2021.
//

import Foundation

extension Optional where Wrapped: StringProtocol {
    var isNilOrEmpty: Bool {
        guard let value = self else { return true }
        
        return value == ""
    }
}
//extension Array where Extra:Encodable{
//    func toJsonString() -> String?{
//        let jsonData = try? JSONEncoder().encode(self)
//        return String(data: jsonData, encoding: .utf8)
//    }
//}
