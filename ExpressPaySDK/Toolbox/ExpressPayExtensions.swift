//
//  ExpressPayExtensions.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 09.03.2021.
//

import Foundation

extension Optional where Wrapped: StringProtocol {
    var isNilOrEmpty: Bool {
        guard let value = self else { return true }
        
        return value == ""
    }
}
