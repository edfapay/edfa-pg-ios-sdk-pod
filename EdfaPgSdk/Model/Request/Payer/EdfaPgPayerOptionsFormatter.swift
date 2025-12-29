//
//  EdfaPgPayerOptionsFormatter.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 15.02.2021.
//

import Foundation

final class EdfaPgPayerOptionsFormatter {

    private let birthdateFormat = DateFormatter()

    init() {
        birthdateFormat.locale = .init(identifier: "en_US")
        birthdateFormat.dateFormat = "yyyy-MM-dd"
    }
    
    func birthdateFormat(payerOptions: EdfaPgPayerOptions?) -> String? {
        guard let birthdate =  payerOptions?.birthdate else { return nil }
        
        return birthdateFormat.string(from:birthdate)
    }
}
