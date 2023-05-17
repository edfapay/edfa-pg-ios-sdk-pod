//
//  ExpressPayPayerOptionsFormatter.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 15.02.2021.
//

import Foundation

final class ExpressPayPayerOptionsFormatter {

    private let birthdateFormat = DateFormatter()

    init() {
        birthdateFormat.locale = .init(identifier: "us")
        birthdateFormat.dateFormat = "yyyy-MM-dd"
    }
    
    func birthdateFormat(payerOptions: ExpressPayPayerOptions?) -> String? {
        guard let birthdate =  payerOptions?.birthdate else { return nil }
        
        return birthdateFormat.string(from:birthdate)
    }
}
