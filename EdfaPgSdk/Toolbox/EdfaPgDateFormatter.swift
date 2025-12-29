//
//  EdfaPgDateFormatter.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 11.03.2021.
//

import Foundation

final class EdfaPgDateFormatter {
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "en_US")
        formatter.dateFormat = "yyyy-mm-dd hh:mm:ss"
        
        return formatter
    }()
    
    static func date(from string: String) -> Date? {
        return try? formatter.date(from: string)
    }
    
    static func string(from: Date) -> String? {
        formatter.string(from: from)
    }
}
