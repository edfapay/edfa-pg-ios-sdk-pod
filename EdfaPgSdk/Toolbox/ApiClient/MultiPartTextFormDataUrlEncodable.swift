//
//  MultiPartFormDataUrlEncodable.swift
//  EdfaPgSdk
//
//  Created by ZIK on 24/02/2024.
//

import Foundation

protocol MultiPartTextFormDataUrlEncodable: Encodable {
    var encodableData: Data? { get }
}

extension MultiPartTextFormDataUrlEncodable {
    var encodableData: Data? {
        guard let data = try? JSONEncoder().encode(self),
              let dict = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any]
        else { return nil }
        
        
        
        let boundary = "boundary-edfapay-pg-formdata"
        var body = Data()
        
        dict.forEach { (key: String, value: Any) in
            body += Data("--\(boundary)\r\n".utf8)
            body += Data("Content-Disposition:form-data; name=\"\(key)\"".utf8)
            body += Data("\r\n\r\n\(value)\r\n".utf8)
        }
        body += Data("--\(boundary)--\r\n".utf8);
        
        
        return body
    }
}
