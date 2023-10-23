//
//  EdfaPgOption.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 15.02.2021.
//

import Foundation

enum EdfaPgOption: String, Encodable {
    case yes = "Y"
    case no = "N"
    
    init(_ boolValue: Bool) {
        self = boolValue ? .yes : .no
    }
}
