//
//  ExpressPayOption.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 15.02.2021.
//

import Foundation

enum ExpressPayOption: String, Encodable {
    case yes = "Y"
    case no = "N"
    
    init(_ boolValue: Bool) {
        self = boolValue ? .yes : .no
    }
}
