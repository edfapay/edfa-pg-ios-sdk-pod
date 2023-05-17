//
//  ExpressPayPayer.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 15.02.2021.
//

import Foundation

/// The required payer data holder.
///
/// See *ExpressPaySaleAdapter, ExpressPayPayerOptions*
public final class ExpressPayPayer {
    
    /// Customer’s name. String up to 32 characters.
    public var firstName: String
    
    /// Customer’s surname. String up to 32 characters.
    public var lastName: String
    
    /// Customer’s address. String up to 255 characters.
    public var address: String
    
    /// Customer’s country. 2-letter code.
    public var country: String
    
    /// Customer’s city. String up to 32 characters.
    public var city: String
    
    /// ZIP-code of the Customer. String up to 32 characters.
    public var zip: String
    
    /// Customer’s email. String up to 256 characters.
    public var email: String
    
    /// Chone customer’s phone. String up to 32 characters.
    public var phone: String
    
    /// IP-address of the Customer. XXX.XXX.XXX.XXX.
    public var ip: String
    
    /// The optional *ExpressPayPayerOptions*.
    public var options: ExpressPayPayerOptions?
    
    /// Create the required payer data holder.
    /// - Parameters:
    ///   - firstName: Customer’s name. String up to 32 characters.
    ///   - lastName: Customer’s surname. String up to 32 characters.
    ///   - address: Customer’s address. String up to 255 characters.
    ///   - country: Customer’s country. 2-letter code.
    ///   - city: Customer’s city. String up to 32 characters.
    ///   - zip: ZIP-code of the Customer. String up to 32 characters.
    ///   - email: Customer’s email. String up to 256 characters.
    ///   - phone: Chone customer’s phone. String up to 32 characters.
    ///   - ip: IP-address of the Customer. XXX.XXX.XXX.XXX.
    ///   - options: The optional *ExpressPayPayerOptions*.
    public init(firstName: String, lastName: String, address: String, country: String, city: String, zip: String, email: String, phone: String, ip: String, options: ExpressPayPayerOptions? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.address = address
        self.country = country
        self.city = city
        self.zip = zip
        self.email = email
        self.phone = phone
        self.ip = ip
        self.options = options
    }
    
    public init(firstName: String, lastName: String, email: String, phone: String, options: ExpressPayPayerOptions? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.address = ""
        self.country = ""
        self.city = ""
        self.zip = ""
        self.email = email
        self.phone = phone
        self.ip = ""
        self.options = options
    }
    
    func jsonForVirtualPurchase() -> [String:Any?]{
        return [
            "name" : "\(firstName) \(lastName)",
            "email" : email,
            "phone" : phone,
            "address" : address,
            "country" : country,
            "city" : city,
            "zip" : zip,
            "ip" : ip,
            "options" : options?.jsonForVirtualPurchase(),
        ]
    }
    
    func name() -> String{
        return "\(firstName) \(lastName)"
    }
}
