//
//  EdfaPayWithCardDetails.swift
//  EdfaPgSdk
//
//  Created by Haseebburiro on 21/10/2024.
//

import Foundation

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

    private var cardNumber: String?
    private var txnId: String?
    private var payer: EdfaPgPayer!
    private var order: EdfaPgSaleOrder!

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

    public func setPayer(_ payer: EdfaPgPayer) -> EdfaPayWithCardDetails {
        self.payer = payer
        return self
    }

    public func setOrder(_ order: EdfaPgSaleOrder) -> EdfaPayWithCardDetails {
        self.order = order
        return self
    }


    public func onTransactionSuccess(_ callback: @escaping TransactionCallback) -> EdfaPayWithCardDetails {
        self.onTransactionSuccess = callback
        return self
    }

    public func onTransactionFailure(_ callback: @escaping TransactionCallback) -> EdfaPayWithCardDetails {
        self.onTransactionFailure = callback
        return self
    }

    public func onError(_ callback: @escaping ErrorCallback) -> EdfaPayWithCardDetails {
        self.onError = callback
        return self
    }

    private func validate() -> Bool {
        return payer != nil && order != nil
    }
    
    
    
    public func doSaleTransaction(
        cardNumber: String,
        expiryMonth: Int,
        expiryYear: Int,
        cvv: String
    ) {
        guard validate() else {
            onError?(["Invalid payment details. Please check all fields."])
            return
        }
        
        let edfaPgCard = EdfaPgCard(
            number: cardNumber,
            expireMonth: Int(expiryMonth),
            expireYear: Int(expiryYear),
            cvv: cvv
        )
        self.cardNumber = cardNumber
        
        let saleOptions:EdfaPgSaleOptions? = nil //EdfaPgSaleOptions(channelId: "", recurringInit: false)
        viewController!.showLoading()
        saleAdapter.execute(order: order,
                            card:edfaPgCard,
                            payer: payer,
                            termUrl3ds: EdfaPgProcessCompleteCallbackUrl,
                            options: saleOptions,
                            auth: false) {(response) in
            
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
    
    
    func openRedirect3Ds(termUrl: String,
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
    
    func redirect(
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
    
    func checkTransactionStatus(
        saleResponse:EdfaPgResponse<EdfaPgSaleResult>,
        transactionId:String
    ){
        print(
            "Checking transaction status for transaction id: \(transactionId)"
        )
        if let cardNumber = cardNumber, let txn = txnId{
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
}

