//
//  CardDetailView.swift
//  ExpressPaySDK
//
//  Created by Zohaib Kambrani on 31/01/2023.
//

import Foundation
import UIKit

public typealias TransactionCallback = ((ExpressPayResponse<ExpressPaySaleResult>?, Any?) -> Void)
public typealias ErrorCallback = (([String]) -> Void)

fileprivate var _onTransactionSuccess:TransactionCallback?
fileprivate var _onTransactionFailure:TransactionCallback?
fileprivate var _onPresent:(() -> Void)?
fileprivate var _onError:ErrorCallback!

fileprivate var _target:UIViewController?
fileprivate var _payer:ExpressPayPayer!
fileprivate var _order:ExpressPaySaleOrder!

// https://github.com/card-io/card.io-iOS-SDK
// https://github.com/orazz/CreditCardForm-iOS
// https://github.com/luximetr/AnyFormatKit

fileprivate var _cardNumber:String?
fileprivate var _txnId:String?
class CardDetailViewController : UIViewController {
    
    var onPresent:(() ->Void)?
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var cardView: CreditCardFormView!
    @IBOutlet weak var txtCardHolderName: UITextField!
    @IBOutlet weak var txtCardNumber: UITextField!
    @IBOutlet weak var txtCardExpiry: UITextField!
    @IBOutlet weak var txtCardCVV: UITextField!
    
    let cardNumberInputController = TextFieldInputController(allowdTextRegex: "")
    let cardExpirationInputController = TextFieldInputController(allowdTextRegex: "")
    let cardCVVInputController = TextFieldInputController(allowdTextRegex: "")
    
    let cardNumberFormatter = DefaultTextInputFormatter(textPattern: "#### #### #### ####")
    let cardExpirationFormatter = DefaultTextInputFormatter(textPattern: "## / ##")
    let cardCVVFormatter = DefaultTextInputFormatter(textPattern: "###")
    
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblCurrency: UILabel!
    
    private lazy var saleAdapter: ExpressPaySaleAdapter = {
        let adapter = ExpressPayAdapterFactory().createSale()
        adapter.delegate = self
        return adapter
    }()
    
    private lazy var getTransactionStatusAdapter: ExpressPayGetTransactionStatusAdapter = {
        let adapter = ExpressPayAdapterFactory().createGetTransactionStatus()
        adapter.delegate = self
        return adapter
    }()
    
    private lazy var getTransactionDetailAdapter: ExpressPayGetTransactionDetailsAdapter = {
        let adapter = ExpressPayAdapterFactory().createGetTransactionDetails()
        adapter.delegate = self
        return adapter
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        self.lblAmount.text = _order.formatedAmountString()
        self.lblCurrency.text = Locale.current.localizedCurrencySymbol(forCurrencyCode: _order.currency)
        
        setupFormatters()
        btnSubmit.isEnabled = false
        
        txtCardHolderName.addDoneButtonOnKeyboard()
        txtCardNumber.addDoneButtonOnKeyboard()
        txtCardExpiry.addDoneButtonOnKeyboard()
        txtCardCVV.addDoneButtonOnKeyboard()
        
        if let _onPresent = onPresent{
            _onPresent()
        }
    }
    
    func setupFormatters(){
        cardNumberInputController.formatter = cardNumberFormatter
        txtCardNumber.delegate = cardNumberInputController
        txtCardNumber.text = cardNumberFormatter.format("")
    
        cardExpirationInputController.formatter = cardExpirationFormatter
        txtCardExpiry.delegate = cardExpirationInputController
        txtCardExpiry.text = cardExpirationFormatter.format("")
    
        cardCVVInputController.formatter = cardCVVFormatter
        txtCardCVV.delegate = cardCVVInputController
        txtCardCVV.text = cardCVVFormatter.format("")
    }
    
    
    
    @IBAction func btnSubmit(_ sender: Any) {
        self.doSaleTransaction()
    }
    
    @IBAction func nameTextChanged(_ sender: UITextField) {
        onChange()
    }
    
    
    @IBAction func numberTextChanged(_ sender: UITextField) {
        onChange()
        sender.textColor = UIColor.black
        let number = cardNumberFormatter.unformat(sender.text)
        if number?.count == 16{
            if isValidCardNumber(number: number){
                txtCardExpiry.becomeFirstResponder()
            }else{
                cardView.shake(duration: 1)
                sender.textColor = UIColor.red
            }
        }else if cardCVVFormatter.unformat(sender.text)?.count == 0{
            txtCardHolderName.becomeFirstResponder()
        }
    }
    
    
    @IBAction func expiryTextChanged(_ sender: UITextField) {
        onChange()
        sender.textColor = UIColor.black
        if cardExpirationFormatter.unformat(sender.text)?.count == 4{
            if isValidExpiry(){
                cardView.paymentCardTextFieldDidBeginEditingCVC()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.txtCardCVV.becomeFirstResponder()
                }
            }else{
                cardView.shake(duration: 1)
                sender.textColor = UIColor.red
            }
        }else if cardCVVFormatter.unformat(sender.text)?.count == 0{
            txtCardNumber.becomeFirstResponder()
        }
    }
    
    
    @IBAction func cvvTextChanged(_ sender: UITextField) {
        onChange()
        sender.textColor = UIColor.black
        if cardCVVFormatter.unformat(sender.text)?.count == 3{
            sender.resignFirstResponder()
            if isValidCVC(){
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.cardView.paymentCardTextFieldDidEndEditingCVC()
                }
            }else{
                cardView.shake(duration: 1)
                sender.textColor = UIColor.red
            }
        }else if cardCVVFormatter.unformat(sender.text)?.count == 0{
            txtCardExpiry.becomeFirstResponder()
        }
    }
    
    func onChange(){
        let name = txtCardHolderName.text
        let number = cardExpirationFormatter.unformat(txtCardNumber.text) ?? ""
        let expiry = cardxExpiry()
        let cvv = cardExpirationFormatter.unformat(txtCardCVV.text)
        

        cardView.cardHolderString = name ?? ""
        cardView.paymentCardTextFieldDidChange(
            cardNumber: number,
            expirationYear: expiry.year,
            expirationMonth: expiry.month,
            cvc: cvv
        )
        
        let unformateNumber = number.replacingOccurrences(of: " ", with: "")
        btnSubmit.isEnabled = isValidExpiry() && isValidCardNumber(number: unformateNumber) && isValidCVC()
    }
    
    func cardxExpiry() -> (month:UInt?, year:UInt?){
        let expiry = cardExpirationFormatter.unformat(txtCardExpiry.text) ?? "0"
        
        if expiry.count == 1 || expiry.count == 2{
            return (UInt(expiry), 0)
        }
        
        if expiry.count == 3{
            return (UInt(expiry.prefix(2)), UInt(expiry.suffix(1)))
        }
        
        if expiry.count == 4{
            return (UInt(expiry.prefix(2)), UInt(expiry.suffix(2)))
        }
        
        return (0,0)
    }
    
    func isValidCardNumber(number:String?) -> Bool{
        return (number ?? "").count == 16 || cardView.cardBrand != .NONE
    }
    
    func isValidExpiry() -> Bool{
        let df = DateFormatter()
        
        df.dateFormat = "MM"
        let month = df.string(from: Date())
        
        df.dateFormat = "yy"
        let year = df.string(from: Date())
        
        let expiry = cardxExpiry()
        
        var valid = false
        if let y1 = expiry.year, let m1 = expiry.month,
           let y2 = UInt(year), let m2 = UInt(month){
            valid = y1+m1 >= y2+m2
        }
        
        return valid
    }
    
    func isValidCVC() -> Bool{
        return txtCardCVV.text?.count == 3
    }
    
}



extension CardDetailViewController : ExpressPayAdapterDelegate{
    func willSendRequest(_ request: ExpressPayDataRequest) {
        
    }
    
    func didReceiveResponse(_ reponse: ExpressPayDataResponse?) {
        
    }
    
    
    func doSaleTransaction(){
        
        
        guard  let number = cardNumberFormatter.unformat(txtCardNumber.text),
               let cvv = cardCVVFormatter.unformat(txtCardCVV.text),
               let expiryYear = cardxExpiry().year,
               let expiryMonth = cardxExpiry().month else {
            return
        }
        
        _cardNumber = number.replacingOccurrences(of: " ", with: "")
        
        
        let _card = ExpressPayCard(number: number, expireMonth: Int(expiryMonth), expireYear: Int(expiryYear + 2000), cvv: cvv)
        
        
        let saleOptions:ExpressPaySaleOptions? = nil //ExpressPaySaleOptions(channelId: "", recurringInit: false)
        
        showLoading()
        saleAdapter.execute(order: _order,
                            card: _card,
                            payer: _payer,
                            termUrl3ds: ExpressPayProcessCompleteCallbackUrl,
                            options: saleOptions,
                            auth: false) { [weak self] (response) in
            
            hideLoading()
            
            guard let self = self else { return }
            
            switch response {
            case .result(let result):
                
                switch result {
                case .recurring(let recurringResult):
                    debugPrint(recurringResult)
                    self.checkTransactionStatus(saleResponse: response, transactionId: recurringResult.transactionId)
                    
                case .secure3d(let result3ds):
                    debugPrint(result3ds)
                    self.openRedirect3Ds(termUrl: result3ds.redirectParams.termUrl,
                                         termUrl3Ds: "",
                                         redirectUrl: result3ds.redirectUrl,
                                         paymentRequisites: result3ds.redirectParams.paymentRequisites)
                    
                case .redirect(let redirectResult):
                    debugPrint(redirectResult)
                    _txnId = redirectResult.transactionId
                    self.redirect(response: response, sale3dsRedirectResponse:redirectResult)
                    
                case .decline(let declineResult):
                    debugPrint(declineResult)
                    self.checkTransactionStatus(saleResponse: response, transactionId: declineResult.transactionId)
                    
                case .success(let successResult):
                    debugPrint(successResult)
                    self.checkTransactionStatus(saleResponse: response, transactionId: successResult.transactionId)
                    
                }
                                
            case .error(let errorResult):
                debugPrint(errorResult)
                _onTransactionFailure?(response, errorResult)
                
            case .failure(let errorResult):
                debugPrint(errorResult)
                _onTransactionFailure?(response, errorResult)
                
            }
        }
    }
    
    
    func openRedirect3Ds(termUrl: String,
                         termUrl3Ds: String,
                         redirectUrl: String,
                         paymentRequisites: String) {
//        let redirect3DsVC = ExpressPayRedirect3dsVC(termUrl: termUrl,
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
    
    func redirect(response:ExpressPayResponse<ExpressPaySaleResult>, sale3dsRedirectResponse:ExpressPaySaleRedirect){
        
        SaleRedirectionView()
            .setup(response: sale3dsRedirectResponse, onTransactionSuccess: { result in
                if let txnId = result.transactionId{
                    self.checkTransactionStatus(saleResponse: response, transactionId: txnId)
                }else{
                    _onTransactionFailure?(response, "Something went wrong (Transaction ID not returned on success response)")
                }

                
            }, onTransactionFailure: { error in
                print("onTransactionFailure: \(error)")
                _onTransactionFailure?(response, error)
                
            })
            .enableLogs()
            .show(owner: self, onStartIn: { viewController in
                print("onStart: \(viewController)")
                
            }, onError: { error in
                print("onError: \(error)")
                
            })

    }
    
    func checkTransactionStatus(saleResponse:ExpressPayResponse<ExpressPaySaleResult>, transactionId:String){
        print("Checking transaction status for transaction id: \(transactionId)")
        if let cardNumber = _cardNumber, let txn = _txnId{
            getTransactionDetailAdapter.execute(
                transactionId: txn,
                payerEmail: _payer.email,
                cardNumber: cardNumber) { response in
                
                    switch response {
                    case .result(let result):
                        
                        switch result {
                        case .success(let successResult):
                            if successResult.status == .settled{
                                print("Transaction settled: \(successResult)")
                                _onTransactionSuccess?(saleResponse, successResult)
                            }else{
                                _onTransactionFailure?(saleResponse, successResult)
                            }
                        }
                                        
                    case .error(let errorResult):
                        debugPrint(errorResult)
                        _onTransactionFailure?(saleResponse, response)
                        
                    case .failure(let errorResult):
                        debugPrint(errorResult)
                        _onTransactionFailure?(saleResponse, errorResult)
                        
                    }
            }
        }
    }
}


public class ExpressCardPay{
    
    public init() {}
    
    func start() -> CardDetailViewController{
        let vc = CardDetailViewController(nibName: "CardDetailViewController", bundle: Bundle(for: CardDetailViewController.self))
        vc.onPresent = _onPresent
        
        if let navigationController = _target as? UINavigationController{
            navigationController.pushViewController(vc, animated: true)
        }else if let viewController = _target{
            viewController.present(vc, animated: true)
        }
        return vc
    }
    
    class public func viewController(target:UIViewController,
                                          payer:ExpressPayPayer,
                                          order:ExpressPaySaleOrder,
                                          transactionSuccess:@escaping TransactionCallback,
                                          transactionFailure:@escaping TransactionCallback,
                                          onError:@escaping ErrorCallback,
                                          onPresent:(() ->Void)?) -> UIViewController{
            _target = target
            _payer = payer
            _order = order
            _onTransactionSuccess = transactionSuccess
            _onTransactionFailure = transactionFailure
            _onError = onError
            _onPresent = onPresent
        
        return CardDetailViewController(nibName: "CardDetailViewController", bundle: Bundle(for: CardDetailViewController.self))
    }
}


// Payment Properties Setters
extension ExpressCardPay{
    
    public func initialize(target:UIViewController, onError:@escaping ErrorCallback, onPresent:(() ->Void)?) -> UIViewController{
        _target = target
        _onError = onError
        _onPresent = onPresent
        return start()
    }
    
    public func on(transactionSuccess:@escaping TransactionCallback) -> ExpressCardPay{
        _onTransactionSuccess = transactionSuccess
        return self
    }
    
    public func on(transactionFailure:@escaping TransactionCallback) -> ExpressCardPay{
        _onTransactionFailure = transactionFailure
        return self
    }
    
    public func set(payer:ExpressPayPayer) -> ExpressCardPay{
        _payer = payer
        return self
    }
    
    public func set(order:ExpressPaySaleOrder) -> ExpressCardPay{
        _order = order
        return self
    }
}


// Payment Properties Validator
private extension ExpressCardPay{
    func validate() -> (valid:Bool, validationErrors:[String] ){
        var errors:[String] = []
        var valid = true
        
        
        if _onTransactionSuccess == nil{
            valid = valid && false
            errors.append("onTransactionFailure not set, try to call function 'ExpressApplePay.on(transactionSuccess:)'")
        }
        
        if _onTransactionFailure == nil{
            valid = valid && false
            errors.append("onTransactionFailure not set, try to call function 'ExpressApplePay.on(transactionFailure:)'")
        }
        
        if !(_order.amount >= 1){
            valid = valid && false
            errors.append("Missing or invalid amount should be greater than 1.00")
        }
        
        if _order.currency.count != 3{
            valid = valid && false
            errors.append("Missing or invalid currency code (example: 'SAR' for Saudi Riyal)")
        }
        
        if _order.country.count != 2{
            valid = valid && false
            errors.append("Missing or invalid country code (example:'SA' for SaudiArabia)")
        }
        
        
        if !(_payer.firstName.isEmpty){
            valid = valid && false
            errors.append("Missing or invalid payer first name")
        }
        
        if !(_payer.lastName.isEmpty){
            valid = valid && false
            errors.append("Missing or invalid payer last name")
        }
        
        if !(_payer.address.isEmpty){
            valid = valid && false
            errors.append("Missing or invalid adress as payer information")
        }
        
        if !(_payer.country.isEmpty){
            valid = valid && false
            errors.append("Missing or invalid  country as payer information")
        }
        
        if !(_payer.city.isEmpty){
            valid = valid && false
            errors.append("Missing or invalid city as payer information")
        }
        
        if !(_payer.phone.isPhoneNumber()){
            valid = valid && false
            errors.append("Missing or invalid phone number. ([0-9٠-٩]{8,})")
        }
        
        if !(_payer.email.isEmail()){
            valid = valid && false
            errors.append("Missing or invalid email. ([A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64})")
        }
        
        return (valid, errors)
    }
}
