//
//  ApplePayVirtualPurchase.swift
//  ExpressPaySDK
//
//  Created by Zohaib Kambrani on 25/01/2023.
//

import Foundation
import PassKit

class ApplePayVirtualPurchase{
    private var json:[String:Any]?
    private var data:Data?
    
    init(payment:PKPayment, payer:ExpressPayPayer) {
        let paymentData = payment.token.paymentData
        let paymentMethod = payment.token.paymentMethod
            
        if let paymentDataJSON = try? JSONSerialization.jsonObject(with: paymentData) as? [String:Any]{
            let paymentJSON = [
                "paymentData" : paymentDataJSON,
                "paymentMethod" : [
                    "displayName" : paymentMethod.displayName ?? "",
                    "network" : paymentMethod.network?.rawValue  ?? "",
                    "type" : paymentMethod.type.name(),
                ],
            ]
            if let data = try? JSONSerialization.data(withJSONObject: paymentJSON),
               let paymentString = String(data: data, encoding: .utf8){
                json = [
                    "brand" : "applepay",
                    "email" : payer.email,
                    "name" : payer.name(),
                    "identifier" : payment.token.transactionIdentifier,
                    "browserInfo" : DeviceDetail().json(),
                    "details" : paymentString
                ]
            }
            if let j = json{
                data = try? JSONSerialization.data(withJSONObject: j)
            }
        }
    }
    
    func getData() -> Data?{
        return data
    }
    
    func getJSON() -> [String:Any]?{
        return json
    }
}

