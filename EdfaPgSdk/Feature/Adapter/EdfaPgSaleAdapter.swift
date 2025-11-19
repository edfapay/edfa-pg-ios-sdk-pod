//
//  EdfaPgSaleAdapter.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 15.02.2021.
//

import Foundation

/// The API Adapter for the SALE operation.
///
/// See *EdfaPgSaleService*
///
/// See *EdfaPgSaleCallback*
///
/// See *EdfaPgSaleResponse*
public final class EdfaPgSaleAdapter: EdfaPgBaseAdapter<EdfaPgSaleService> {
    
    private let amountFormatter = EdfaPgAmountFormatter()
    private let cardFormatter = EdfaPgCardFormatter()
    private let payerOptionsFormatter = EdfaPgPayerOptionsFormatter()
    
    /// Executes the *EdfaPgSaleService.sale* request.
    /// - Parameters:
    ///   - order: the *EdfaPgSaleOrder*.
    ///   - card: the *EdfaPgCard*.
    ///   - payer: the *EdfaPgPayer*.
    ///   - termUrl3ds: URL to which Customer should be returned after 3D-Secure. String up to 1024 characters.
    ///   - options: the *EdfaPgSaleOptions*. Optional.
    ///   - auth: indicates that transaction must be only authenticated, but not captured.
    ///   - callback: the *EdfaPgSaleCallback*.
    /// - Returns: the *URLSessionDataTask*
    @discardableResult
    public func execute(order: EdfaPgSaleOrder,
                        card: EdfaPgCard,
                        payer: EdfaPgPayer,
                        extras:[Extra] = [],
                        termUrl3ds: String,
                        options: EdfaPgSaleOptions? = nil,
                        auth: Bool,
                        callback: @escaping EdfaPgSaleCallback) -> URLSessionDataTask {
        let hash = EdfaPgHashUtil.hash(email: payer.email,
                                          cardNumber: card.number)!
        let payerOptions = payer.options
        
        
        let jsonData = try? JSONEncoder().encode(extras)
        if jsonData == nil{
            print("Error encoding the extras to json")
        }
        
        let extraJson = String(data: jsonData ?? Data() , encoding: .utf8)
        
        return procesedRequest(action: .sale,
                               params: .init(channelId: options?.channelId,
                                             orderId: order.id,
                                             orderAmount: amountFormatter.amountFormat(for: order.amount) ?? "",
                                             orderCurrency: order.currency,
                                             orderDescription: order.description,
                                             extras: extraJson ?? "[]",
                                             cardNumber: card.number,
                                             cardExpireMonth: cardFormatter.expireMonthFormat(for: card) ?? "",
                                             cardExpireYear: cardFormatter.expireYearFormat(for: card) ?? "",
                                             cardCvv2: card.cvv,
                                             payerFirstName: payer.firstName,
                                             payerLastName: payer.lastName,
                                             payerMiddleName: payerOptions?.middleName,
                                             payerBirthDate: payerOptionsFormatter.birthdateFormat(payerOptions: payerOptions),
                                             payerAddress: payer.address,
                                             payerAddress2: payerOptions?.address2,
                                             payerCountry: payer.country,
                                             payerState: payerOptions?.state,
                                             payerCity: payer.city,
                                             payerZip: payer.zip,
                                             payerEmail: payer.email,
                                             payerPhone: payer.phone,
                                             payerIp: payer.ip,
                                             termUrl3ds: termUrl3ds,
                                             recurringInit: EdfaPgOption(options?.recurringInit ?? false),
                                             auth: EdfaPgOption(auth),
                                             hash: hash),
                               callback: callback)
    }
}
