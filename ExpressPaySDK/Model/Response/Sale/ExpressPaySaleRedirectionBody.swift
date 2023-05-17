//
//  ExpressPaySaleRedirectionBody.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 09.03.2021.
//

import Foundation

public struct ExpressPay3dsResponse{
    public let orderId: String?
    public let transactionId: String?
    public let ciphertext: String?
    public let nonce: String?
    public let tag: String?
    
    public let result: Result?
    public let gatewayRecommendation: GatewayRecommendation?
    
}

extension ExpressPay3dsResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case status = "result"
        case orderId = "order.id"
        case  transactionId = "transaction.id"
        case ciphertext = "encryptedData.ciphertext"
        case nonce = "encryptedData.nonce"
        case tag = "encryptedData.tag"
        case gatewayRecommendation = "response.gatewayRecommendation"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        orderId = try? container.decode(String.self, forKey: .orderId)
        transactionId = try? container.decode(String.self, forKey: .transactionId)
        ciphertext = try? container.decode(String.self, forKey: .ciphertext)
        nonce = try? container.decode(String.self, forKey: .nonce)
        tag = try? container.decode(String.self, forKey: .tag)
        
        result = try? container.decode(Result.self, forKey: .status)
        gatewayRecommendation = try? container.decode(GatewayRecommendation.self, forKey: .gatewayRecommendation)
    }
    
    
    public func encode(to encoder: Encoder) throws {
        var container = try encoder.container(keyedBy: CodingKeys.self)
        try container.encode(result, forKey: .status)
        try container.encode(orderId, forKey: .orderId)
        try container.encode(transactionId, forKey: .transactionId)
        try container.encode(ciphertext, forKey: .ciphertext)
        try container.encode(nonce, forKey: .nonce)
        try container.encode(tag, forKey: .tag)
        try container.encode(gatewayRecommendation, forKey: .gatewayRecommendation)

    }
}



public enum Result: String, Codable {
    case success = "SUCCESS"
    case failure = "FAILURE"
}


public enum GatewayRecommendation: String, Codable {
    case proceed = "PROCEED"
    case dontProceed = "DO_NOT_PROCEED"
}


//-------------
// Success
//-------------
//order.id:3d9f8eda-9a62-11ed-993b-7644d81c3cdb
//transaction.id:42674548-9a62-11ed-97e7-7644d81c3cdb
//response.gatewayRecommendation:PROCEED
//encryptedData.ciphertext:RuXlHnhMCn1%2FgOYB2xtD31UbHDXCvngWNwFVwXIbq%2FWot331n87NoSfR06gQqUZwD5Uz4oiNCt%2BNsgme7WIAeIVrlZSa8%2BU0SEHNP2EsuD4c99i6o4NcBO2Y2ijW1cm20dSpmALBTinEp%2FPiKUB3ZyxUA6Hpwyow14v0yf1QkOpjKC6sEpphsKEgXgLroy5RZCXlQIer2aiDBNHU%2BPfkJYnLO1Yi6B9zePlX3V6EV4L4roIEBqwC7CP9el4ELB%2F2xNM%2FmrTsxD1E1H0wh4dHr260Phrt8UYLKJs3aNSV849qHRDz%2FHGWlRE6o4d1zK2Abpmk4HEER2c1wxZMXBfeQb3%2BEw8QsnE7WDVPVYuvQFQRGp2Vuj5TTTCuXMxPno0Lr2QhIMvp9FxrD39k%2BvBCS7Ih8xh8phPywqP28fbCJN2kzzxuIvutWWrk46w%2BsQpXY16q5lqmx1KiEujVo%2BfHrCeI5mSeZQd%2FBoPYeXmuG3lq1MoKkCFfvJ2%2B0CS9tmq9vOUnn%2Fr3lw0k5lCF85eLU8A1R3kcR1ary82wpP8X7QCcJ2SVPRLEL%2FFvjuhmpPJor3tYUBsu8KRqQpCygc6qVRPXyfi65LPwVg%3D%3D
//encryptedData.nonce:BWZQ41zLU%2FOAABNa
//encryptedData.tag:TtOTq3VPVlu9roXQFwAd4Q%3D%3D
//result:SUCCESS


//-------------
// Failure
//-------------
//order.id:2733ed20-9a63-11ed-af32-72bdaca72cd1
//transaction.id:28bfc42a-9a63-11ed-b6ac-7644d81c3cdb
//response.gatewayRecommendation:DO_NOT_PROCEED
//encryptedData.ciphertext:tyx%2FqurSoN39Vz8Ml84xnwHjRHC%2Fz1pTL9RIO%2F5NNK2juGljgM7D1xY1FEh8%2Bzej9pkavs5ZftUa5PQeVJ83TzLJaKRbT0o0ioOKr%2FDXegQxq9CxCo0P3yW8oB6eEf9dftXei3exOn44hfDE4RIJu%2FaQFCPZ7kBm83cFCWwgDukV9wf9XStNJwQKlByKAtuMK2w4v%2FjEqhAb084xZK7zY0vduqceUvdOK2HvQ%2FgOI49E%2FK99af76bTib065bbAZBT%2FdiFa8dcb3YQ%2FIxrxWivZq0%2F2gqA9%2BFJbPL5m9QnBEG5v%2FoVlOI68BflGxIbmzKv%2BT5yf9CdJY9%2F9Eu824v5SVT%2B89%2F3WXbvkPmAeTBHIh6gHNeW0erlJeD%2B4lJi8E3TqbV4oZVFTbpeui3%2FxuXKsJqrEklp0hdGu3bLMc7rulPW45d6hW9ynl%2F97jQdJgsRsJFw6OCXXbt%2BMvyZGDuL%2FgS109xsTuxIUYzdWIfxly9uHF0dxTTfcMjKWC53M%2B9P1E%3D
//encryptedData.nonce:BWZQ41zLU%2FOAABNj
//encryptedData.tag:ZSkkJmVdaHapEWC5EAdutQ%3D%3D
//result:FAILURE
