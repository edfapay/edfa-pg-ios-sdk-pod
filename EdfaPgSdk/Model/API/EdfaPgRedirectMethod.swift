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
}
