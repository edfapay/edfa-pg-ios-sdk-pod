//
//  ExpressPayHashUtil.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 08.03.2021.
//

import Foundation
import CommonCrypto

/// Hash is signature rule used either to validate your requests to payment platform or to validate callback from
/// payment platform to your system.
final class ExpressPayHashUtil {
    
    /// The returned has must be md5 encoded string calculated by rules:
    ///
    /// Hash is calculated by the formula (Initial calculation):
    /// md5(strtoupper(strrev(email).CLIENT_PASS.strrev(substr(card_number,0,6).substr(card_number,-4))))
    ///
    /// Hash with the [transactionId] is calculated by the formula (Verify calculation):
    /// md5(strtoupper(strrev(email).CLIENT_PASS.trans_id.strrev(substr(card_number,0,6).substr(card_number,-4)))
    /// - Parameters:
    ///   - email: The payer email.
    ///   - cardNumber: The payer card number.
    ///   - transactionId: Optional value. Used when the transaction ID is known.
    /// - Returns: The *md5* hash String.
    static func hash(email: String,
                     cardNumber: String,
                     transactionId: String? = nil) -> String? {
        let emailHash = String(email.reversed())
        let clientPass = ExpressPaySDK.shared.credentials.clientPass
        
        let cardNumberHash1 = cardNumber.prefix(6)
        let cardNumberHash2 = cardNumber.suffix(4)
        let cardNumberHash = String((cardNumberHash1 + cardNumberHash2).reversed())
        
        let sum = emailHash.appending(clientPass)
            .appending(transactionId ?? "")
            .appending(cardNumberHash)
        
        return md5(from: sum.uppercased())
    }
    

    
    
    ////Example: Must be SHA1 of MD5 encoded string (uppercased): order_number + order_amount + order_currency + order_description + password
    /// The returned has must be encoded string calculated by rules:
    ///
    /// sha1(md5(strtoupper(order_number.order_amount.order_currency.order_description.merchant_password)))
    /// - Parameters:
    ///   - number: The order unique number/id.
    ///   - amount: The order amount.
    ///   - currency: The order currency
    ///   - description: The order description
    /// - Returns: The *md5* hash String.
    static func hashVirtualPurchaseOrder(number:String, amount:String, currency:String, description:String) -> String? {
        let clientPass = ExpressPaySDK.shared.credentials.clientPass
        
        if let md5 = md5(from: "\(number)\(amount)\(currency)\(description)\(clientPass)".uppercased()){
            return sha1(string:md5)
        }
        return nil
    }
    
    private static func md5(from string: String) -> String? {
        let data = Data(string.utf8)
        
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        
        return hash.map { String(format: "%02x", $0) }.joined()
    }
    
    private static func sha1(string:String) -> String {
        let data = Data(string.utf8)
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0.baseAddress, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
}
