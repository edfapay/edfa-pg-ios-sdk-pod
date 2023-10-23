//
//  EdfaPgCallback.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 15.02.2021.
//

import Foundation

/// EdfaPgCallback
/// - Result: the successful result type of the *Response*
public typealias EdfaPgCallback<Result: Decodable> = (EdfaPgResponse<Result>) -> Void

/// EdfaPgResponse
/// - Result: the successful result type of the *Response*
public enum EdfaPgResponse<Result: Decodable> {
    
    /// The custom suucess result case
    case result(Result)
    
    /// The custom error result case
    case error(EdfaPgError)
    
    /// The unhandled exception case
    case failure(Error)
}
