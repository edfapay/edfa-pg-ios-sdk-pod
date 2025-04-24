//
//  EdfaPayWithCardDetails.swift
//  EdfaPgSdk
//
//  Created by Haseebburiro on 21/10/2024.
//

import Foundation
import UIKit

public class EdfaPayWithCardDetails: EdfaPgAdapterDelegate {
    
    private weak var viewController: UIViewController?

    public func willSendRequest(_ request: EdfaPgDataRequest) {
        
    }
    
    public func didReceiveResponse(_ reponse: EdfaPgDataResponse?) {
        
    }
    

    public typealias TransactionCallback = (
        (EdfaPgResponse<EdfaPgSaleResult>?, Any?) -> Void
    )
    public typealias ErrorCallback = (([String]) -> Void)

    private var onTransactionSuccess: TransactionCallback?
    private var onTransactionFailure: TransactionCallback?
    private var onError: ErrorCallback?

//    private var cardNumber: String?
    private var txnId: String?
    private var payer: EdfaPgPayer!
    private var language: EdfaPayLanguage!
    private var order: EdfaPgSaleOrder!
    private var card: EdfaPgCard!
    private var recurring: Bool = false
    private var auth: Bool = false

    
    
    

    private lazy var saleAdapter: EdfaPgSaleAdapter = {
        let adapter = EdfaPgAdapterFactory().createSale()
        adapter.delegate = self
        return adapter
    }()

    private lazy var getTransactionStatusAdapter: EdfaPgGetTransactionStatusAdapter = {
        let adapter = EdfaPgAdapterFactory().createGetTransactionStatus()
        adapter.delegate = self
        return adapter
    }()
    
    private lazy var getTransactionDetailAdapter: EdfaPgGetTransactionDetailsAdapter = {
        let adapter = EdfaPgAdapterFactory().createGetTransactionDetails()
        adapter.delegate = self
        return adapter
    }()

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public func set(payer: EdfaPgPayer) -> EdfaPayWithCardDetails {
        self.payer = payer
        return self
    }

    public func set(language: EdfaPayLanguage) -> EdfaPayWithCardDetails {
        self.language = language
        return self
    }

    public func set(order: EdfaPgSaleOrder) -> EdfaPayWithCardDetails {
        self.order = order
        return self
    }
    public func set(card: EdfaPgCard) -> EdfaPayWithCardDetails {
        self.card = card
        return self
    }

    public func set(recurring: Bool) -> EdfaPayWithCardDetails {
        self.recurring = recurring
        return self
    }

    public func set(auth: Bool) -> EdfaPayWithCardDetails {
        self.auth = auth
        return self
    }

    public func on(transactionSuccess: @escaping TransactionCallback) -> EdfaPayWithCardDetails {
        self.onTransactionSuccess = transactionSuccess
        return self
    }

    public func on(transactionFailure: @escaping TransactionCallback) -> EdfaPayWithCardDetails {
        self.onTransactionFailure = transactionFailure
        return self
    }

//    public func onError(_ callback: @escaping ErrorCallback) -> EdfaPayWithCardDetails {
//        self.onError = callback
//        return self
//    }

    private func validate() -> Bool {
        return payer != nil && order != nil
    }
 
    public func initialize(onError:@escaping ErrorCallback){
        
        self.onError = onError
        doSaleTransaction()
        
    }

    
    
    private func doSaleTransaction( ) {
//        guard validate() else {
//            onError?(["Invalid payment details. Please check all fields."])
//            return
//        }
        // Validate that payer has been set and is valid
        guard let payer = payer else {
            onError?(["Payer information is missing. Please call 'set(payer:)' before initializing."])
            return
        }
        guard let _ = order else {
            onError?(["Order information is missing. Please call 'set(order:)' before initializing."])
               return
        }
        
        guard let edfaPgCard = card else {
            onError?(["Card information is missing. Please call 'set(card:)' before initializing."])
            return
        }

        // Validate payer and order
        let (isPayerValid, payerErrors) = validatePayer()
        let (isOrderValid, orderErrors) = validateOrder()
        let validationErrors = payerErrors + orderErrors
           
        if !isPayerValid || !isOrderValid {
            onError?(validationErrors)
            return
        }
        
//        let edfaPgCard = EdfaPgCard(
//            number: cardNumber,
//            expireMonth: Int(expiryMonth),
//            expireYear: Int(expiryYear),
//            cvv: cvv
//        )
//         self.cardNumber = edfaPgCard.number
        
        let saleOptions:EdfaPgSaleOptions? = EdfaPgSaleOptions(channelId: "", recurringInit: self.recurring)
        viewController!.showLoading()
        saleAdapter.execute(order: order,
                            card:edfaPgCard,
                            payer: payer,
                            termUrl3ds: EdfaPgProcessCompleteCallbackUrl,
                            options: saleOptions,
                            auth: auth) {(response) in
            
            hideLoading()
                        
            switch response {
            case .result(let result):
                switch result {
                case .recurring(let recurringResult):
                    debugPrint(recurringResult)
                    self.checkTransactionStatus(
                        saleResponse: response,
                        transactionId: recurringResult.transactionId
                    )
                    
                case .secure3d(let result3ds):
                    debugPrint(result3ds)
                    self.openRedirect3Ds(termUrl: result3ds.redirectParams.termUrl,
                                         termUrl3Ds: "",
                                         redirectUrl: result3ds.redirectUrl,
                                         paymentRequisites: result3ds.redirectParams.paymentRequisites)
                    
                case .redirect(let redirectResult):
                    debugPrint(redirectResult)
                    self.txnId = redirectResult.transactionId
                    self.redirect(
                        response: response,
                        sale3dsRedirectResponse:redirectResult
                    )
                    
                case .decline(let declineResult):
                    debugPrint(declineResult)
                    self.checkTransactionStatus(
                        saleResponse: response,
                        transactionId: declineResult.transactionId
                    )
                    
                case .success(let successResult):
                    debugPrint(successResult)
                    self.checkTransactionStatus(
                        saleResponse: response,
                        transactionId: successResult.transactionId
                    )
                    
                }
                                
            case .error(let errorResult):
                debugPrint(errorResult)
                self.onTransactionFailure?(response, errorResult)
                
            case .failure(let errorResult):
                debugPrint(errorResult)
                self.onTransactionFailure?(response, errorResult)
                
            }
        }
    }
    
    
    private func openRedirect3Ds(termUrl: String,
                         termUrl3Ds: String,
                         redirectUrl: String,
                         paymentRequisites: String) {
        //        let redirect3DsVC = EdfaPgRedirect3dsVC(termUrl: termUrl,
        //                                                   termUrl3Ds: termUrl3Ds,
        //                                                   redirectUrl: redirectUrl,
        //                                                   paymentRequisites: paymentRequisites)
        //        redirect3DsVC.completion = { [unowned self] in
        //            if ($0) { self.showInfo("The 3ds operation has been completed.") }
        //        }
        //
        //        let navigation = UINavigationController(rootViewController: redirect3DsVC)
        //        present(navigation, animated: true, completion: nil)
    }
    
    private func redirect(
        response:EdfaPgResponse<EdfaPgSaleResult>,
        sale3dsRedirectResponse:EdfaPgSaleRedirect
    ){
        
        SaleRedirectionView()
            .setup(
                response: sale3dsRedirectResponse,
                onTransactionSuccess: { result in
                    if let txnId = result.transactionId{
                        self.checkTransactionStatus(
                            saleResponse: response,transactionId: txnId)
                    }else{
                        self.onTransactionFailure?(response,"Something went wrong (Transaction ID not returned on success response)"
                    )
     }

                
 },
onTransactionFailure: { error in
    print("onTransactionFailure: \(error)")
    self.onTransactionFailure?(response, error)
                
})
            .enableLogs()
            .show(owner: viewController!, onStartIn: { viewController in
                print("onStart: \(viewController)")
                
            }, onError: { error in
                print("onError: \(error)")
                
            })

    }
    
    private func checkTransactionStatus(
        saleResponse:EdfaPgResponse<EdfaPgSaleResult>,
        transactionId:String
    ){
        print(
            "Checking transaction status for transaction id: \(transactionId)"
        )
        let cardNumber = card.number
        if  let txn = txnId{
            getTransactionDetailAdapter.execute(
                transactionId: txn,
                payerEmail: payer.email,
                cardNumber: cardNumber) { response in
                
                    switch response {
                    case .result(let result):
                        
                        switch result {
                        case .success(let successResult):
                            if successResult.status == .settled{
                                print("Transaction settled: \(successResult)")
                                self.onTransactionSuccess?(
                                    saleResponse,
                                    successResult
                                )
                            }else{
                                self.onTransactionFailure?(
                                    saleResponse,
                                    successResult
                                )
                            }
                        }
                                        
                    case .error(let errorResult):
                        debugPrint(errorResult)
                        self.onTransactionFailure?(saleResponse, response)
                        
                    case .failure(let errorResult):
                        debugPrint(errorResult)
                        self.onTransactionFailure?(saleResponse, errorResult)
                        
                    }
                }
        }
    }
    
    
    private func validateOrder() -> (Bool, [String]) {
        var errors = [String]()
        var isValid = true
        
        // Check if _order is set
        guard let order = order else {
            errors.append("Order information is missing. Please call 'set(order:)' before initializing.")
            return (false, errors)
        }

        // Validate amount
        if order.amount < 1 {
            isValid = false
            errors.append("Missing or invalid amount; it should be greater than or equal to 1.00.")
        }

        // Validate currency code (should be exactly 3 characters)
        if order.currency.count != 3 {
            isValid = false
            errors.append("Missing or invalid currency code (example: 'SAR' for Saudi Riyal).")
        }

        // Validate country code (should be exactly 2 characters)
        if order.country.count != 2 {
            isValid = false
            errors.append("Missing or invalid country code (example: 'SA' for Saudi Arabia).")
        }

        return (isValid, errors)
    }

    
    private func validatePayer() -> (Bool, [String]) {
        var errors = [String]()
        var isValid = true

        // Use optional binding to check each field safely

        if let firstName = payer?.firstName, firstName.isEmpty {
            isValid = false
            errors.append("Missing or invalid payer first name")
        } else if payer?.firstName == nil {
            isValid = false
            errors.append("Payer first name is missing")
        }

        if let lastName = payer?.lastName, lastName.isEmpty {
            isValid = false
            errors.append("Missing or invalid payer last name")
        } else if payer?.lastName == nil {
            isValid = false
            errors.append("Payer last name is missing")
        }

        if let address = payer?.address, address.isEmpty {
            isValid = false
            errors.append("Missing or invalid address as payer information")
        } else if payer?.address == nil {
            isValid = false
            errors.append("Payer address is missing")
        }

        if let country = payer?.country, country.isEmpty {
            isValid = false
            errors.append("Missing or invalid country as payer information")
        } else if payer?.country == nil {
            isValid = false
            errors.append("Payer country is missing")
        }

        if let city = payer?.city, city.isEmpty {
            isValid = false
            errors.append("Missing or invalid city as payer information")
        } else if payer?.city == nil {
            isValid = false
            errors.append("Payer city is missing")
        }

        if let phone = payer?.phone, !phone.isPhoneNumber() {
            isValid = false
            errors.append("Missing or invalid phone number. ([0-9٠-٩]{8,})")
        } else if payer?.phone == nil {
            isValid = false
            errors.append("Payer phone number is missing")
        }

        if let email = payer?.email, !email.isEmail() {
            isValid = false
            errors.append("Missing or invalid email. ([A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64})")
        } else if payer?.email == nil {
            isValid = false
            errors.append("Payer email is missing")
        }

        return (isValid, errors)
    }
    
}

