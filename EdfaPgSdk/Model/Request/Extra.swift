//
//  Extra.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 15.02.2021.
//

import Foundation


public class Extra: Codable {
    
    public var type: String
    public var name: String
    public var value: String
    
    public init(type: String, name: String, value: String) {
        self.type = type
        self.name = name
        self.value = value
    }
}
