//
//  EdfaPgRedirectMethod.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 15.02.2021.
//

import Foundation

/// The method of transferring parameters (POST/GET).
/// 
/// See *EdfaPgSale3ds*
public enum EdfaPgRedirectMethod: String, Codable {
    
    /// GET redirect method value.
    case get = "GET"
    
    /// POST redirect method value.
    case post = "POST"
    
    
    /// Undefined Method
    case undefined
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = EdfaPgRedirectMethod(rawValue: rawValue.uppercased()) ?? .undefined
    }
}
