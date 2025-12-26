//
//  XWWWFormUrlEncodable.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 11.03.2021.
//

import Foundation

protocol JSONBodyEncodable: Encodable {
    var encodableData: Data? { get }
}

extension JSONBodyEncodable {
    var encodableData: Data? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return data
    }
}
