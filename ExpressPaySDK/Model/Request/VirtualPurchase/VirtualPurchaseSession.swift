//
//  VirtualPurchase.swift
//  ExpressPaySDK
//
//  Created by Zohaib Kambrani on 25/01/2023.
//

import Foundation
/*
 {
     "merchant_key": "58e9490c-000c-11ed-000-76632760000",
     "operation": "purchase",
     "success_url": "http://example.com/success",
     "cancel_url ": "http://example.com/failure",
     "hash": "52a0d81674aee2e58900e3469476ce8519a8453b",
     "order": {
         "number": "04e5e82476af42b886019f2a95d6a677.720db4bd8e1448dab6853c679afa449b.c88784cc61c0483a937b7384200755bd",
         "amount": 1.01,
         "currency": "SAR",
         "description": "04E5E8"
     },
     "customer": {
         "name": "Zohaib Kambrani",
         "email": "a2zzuhaib@gmail.com"
     },
     "methods": [
         "applepay"
     ]
 }
 */

public final class VirtualPurchaseSession {
    
    public var operation = "purchase"
    public var method:String
    
    public var merchant_key: String
    public var success_url: String
    public var cancel_url: String
    public var hash: String
    public var order: ExpressPaySaleOrder
    public var customer: ExpressPayPayer
    
    
    public init(
        hash: String,
        method: String,
        merchant_key:String,
        success_url: String,
        cancel_url: String,
        order: ExpressPaySaleOrder,
        customer: ExpressPayPayer) {
         
            self.hash =  hash
            self.method =  method
            self.merchant_key =  merchant_key
            self.success_url =  success_url
            self.cancel_url =  cancel_url
            self.order =  order
            self.customer =  customer
            
    }
    
    func json() -> [String:Any]{
        return [
            "merchant_key": merchant_key,
            "operation": operation,
            "success_url": success_url,
            "cancel_url ": cancel_url,
            "hash": hash,
            "order": order.jsonForVirtualPurchase(),
            "customer": customer.jsonForVirtualPurchase(),
            "methods": [
                method
            ]
        ]
    }
    
    func data() -> Data?{
        return try? JSONSerialization.data(withJSONObject: json())
    }
}

