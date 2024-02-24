//
//  ApplePayVirtualPurchase.swift
//  EdfaPgSdk
//
//  Created by Zohaib Kambrani on 25/01/2023.
//

import Foundation
import PassKit

class ApplePayPaymentData{
    private var json:[String:Any]?
    private var string:String?
    private var data:Data?
    
    init(payment:PKPayment, payer:EdfaPgPayer) {
        let paymentToken = payment.token
        let paymentMethod = payment.token.paymentMethod
            
        if let paymentDataJSON = try? JSONSerialization.jsonObject(with: paymentToken.paymentData) as? [String:Any]{
            let paymentJSON:[String : Any] = [
                "paymentData" : paymentDataJSON,
                "paymentMethod" : [
                    "displayName" : paymentMethod.displayName ?? "",
                    "network" : paymentMethod.network?.rawValue  ?? "",
                    "type" : paymentMethod.type.name(),
                ],
                "transactionIdentifier" : paymentToken.transactionIdentifier
            ]
            
            if let data = try? JSONSerialization.data(withJSONObject: paymentJSON),
               let paymentString = String(data: data, encoding: .utf8){
                json = [
                    "brand" : "applepay",
                    "email" : payer.email,
                    "name" : payer.name(),
                    "identifier" : paymentToken.transactionIdentifier,
                    "browserInfo" : DeviceDetail().json(),
                    "details" : paymentString
                ]
            }
            if let j = json{
                data = try? JSONSerialization.data(withJSONObject: j)
                string = String(data: data ?? Data(), encoding: .utf8)
            }
        }
    }
    
    func getData() -> Data?{
        return data
    }
    
    func getJSON() -> [String:Any]?{
        return json
    }
    
    func getString() -> String?{
        return string
    }
}

