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
public final class EdfaPgVirtualSaleAdapter: EdfaPgVirtualBaseAdapter<EdfaPgVirtualSaleService> {
    
    private let amountFormatter = EdfaPgAmountFormatter()
    private let cardFormatter = EdfaPgCardFormatter()
    private let payerOptionsFormatter = EdfaPgPayerOptionsFormatter()
    
    @discardableResult
    public func execute(
        brand:String,
        identifier:String,
        returnUrl:String,
        paymentToken:String,
        order: EdfaPgSaleOrder,
        payer: EdfaPgPayer,
        options: EdfaPgSaleOptions? = nil,
        callback: @escaping EdfaPgSaleVirtualTransactionResultCallback
    ) -> URLSessionDataTask {
        
        let hash = EdfaPgHashUtil.hashApplePayVirtual(
            identifier: identifier,
            number: order.id,
            amount: order.formatedAmountString(),
            currency: order.currency
        )
        
        let payerOptions = payer.options
        
        return procesedRequest(
            action: .sale,
            params: .init(
             orderId: order.id,
             orderAmount: amountFormatter.amountFormat(for: order.amount) ?? "",
             orderCurrency: order.currency,
             orderDescription: order.description,
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
             hash: hash!,
             brand: brand,
             identifier: identifier,
             returnUrl: returnUrl,
             paymentToken: paymentToken
            ),
            callback: callback
        )
    }
}
