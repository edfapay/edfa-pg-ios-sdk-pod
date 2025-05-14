//
//  CardDetailView.swift
//  EdfaPgSdk
//
//  Created by Zohaib Kambrani on 31/01/2023.
//

import Foundation
import UIKit

public typealias TransactionCallback = (
    (EdfaPgResponse<EdfaPgSaleResult>?, Any?) -> Void
)
public typealias ErrorCallback = (([String]) -> Void)

fileprivate var _onTransactionSuccess:TransactionCallback?
fileprivate var _onTransactionFailure:TransactionCallback?
fileprivate var _onPresent:(() -> Void)?
fileprivate var _onError:ErrorCallback!

fileprivate var _target:UIViewController?
fileprivate var _payer:EdfaPgPayer!
fileprivate var _order:EdfaPgSaleOrder!
fileprivate var _designType:EdfaPayDesignType = .one
fileprivate var _languageCode:EdfaPayLanguage = .en
fileprivate var _recurring:Bool = false
fileprivate var _auth:Bool = false

// https://github.com/card-io/card.io-iOS-SDK
// https://github.com/orazz/CreditCardForm-iOS
// https://github.com/luximetr/AnyFormatKit

fileprivate var _cardNumber:String?
fileprivate var _txnId:String?
class CardDetailViewController : UIViewController {
    
    @IBOutlet weak var lblCardDes: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblMonthYear: UILabel!
    @IBOutlet weak var lblValidThru: UILabel!
    @IBOutlet weak var lblCvv: UILabel!
    
    @IBOutlet weak var lblCardHolder: UILabel!
    @IBOutlet weak var lblCardnumber: UILabel!
    @IBOutlet weak var lblCvvField: UILabel!
    @IBOutlet weak var lblExpiryField: UILabel!
    @IBOutlet weak var lblPowredBy: UILabel!
    
    var onPresent:(() ->Void)?
    
    @IBOutlet weak var btnSubmit: UIButton!
    //@IBOutlet weak var cardView: CreditCardFormView!
    @IBOutlet weak var txtCardHolderName: UITextField!
    @IBOutlet weak var txtCardNumber: UITextField!
    @IBOutlet weak var txtCardExpiry: UITextField!
    @IBOutlet weak var txtCardCVV: UITextField!
    
    let cardNumberInputController = TextFieldInputController(
        allowdTextRegex: ""
    )
    let cardExpirationInputController = TextFieldInputController(
        allowdTextRegex: ""
    )
    let cardCVVInputController = TextFieldInputController(allowdTextRegex: "")
    @IBOutlet weak var cardViewCardNumber: UITextField!
    @IBOutlet weak var cardViewCardName: UITextField!
    @IBOutlet weak var cardViewCardExpiry: UITextField!
    @IBOutlet weak var cardViewCvv: UITextField!
    let cardNumberFormatter = DefaultTextInputFormatter(
        textPattern: "#### #### #### ####"
    )
    let cardExpirationFormatter = DefaultTextInputFormatter(
        textPattern: "## / ##"
    )
    let cardCVVFormatter = DefaultTextInputFormatter(textPattern: "####")
    
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblCurrency: UILabel!
    
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
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        self.lblAmount.text = _order.formatedAmountString()
        self.lblCurrency.text = Locale.current
            .localizedCurrencySymbol(forCurrencyCode: _order.currency)
        // Set localized text for button
        setupTargets()
        setupFormatters()
        setLocalization(langugeCode:_languageCode)
        btnSubmit.isEnabled = false
        btnSubmit.alpha = 0.5
        
        txtCardHolderName.addDoneButtonOnKeyboard()
        txtCardNumber.addDoneButtonOnKeyboard()
        txtCardExpiry.addDoneButtonOnKeyboard()
        txtCardCVV.addDoneButtonOnKeyboard()
        
        if let _onPresent = onPresent{
            _onPresent()
        }
        
        addKeyboardNotificationObserver()
            
    }
    
    func addKeyboardNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    // Move the view up when keyboard appears
       @objc func keyboardWillShow(notification: NSNotification) {
           if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
               let keyboardHeight = keyboardFrame.height
               self.view.frame.origin.y = -keyboardHeight / 2  // Adjust as needed
           }
       }
       
       // Move the view back down when keyboard hides
       @objc func keyboardWillHide(notification: NSNotification) {
           self.view.frame.origin.y = 0
       }

       deinit {
           NotificationCenter.default.removeObserver(self)
       }
    
    
    @IBAction func handleTapOnCardHolder(_ sender: UITapGestureRecognizer) {
        txtCardHolderName.becomeFirstResponder()
    }
    @IBAction func handleTapOnCardNumber(_ sender: UITapGestureRecognizer) {
        txtCardNumber.becomeFirstResponder()
    }
    
    @IBAction func handleTapOnCardCvv(_ sender: UITapGestureRecognizer) {
        txtCardCVV.becomeFirstResponder()
    }
    
    @IBAction func handleTapOnCardExpiry(_ sender: UITapGestureRecognizer) {
        txtCardExpiry.becomeFirstResponder()
    }
    
    
    
    func setupFormatters(){
        cardNumberInputController.formatter = cardNumberFormatter
        txtCardNumber.delegate = cardNumberInputController
        txtCardNumber.text = cardNumberFormatter.format("")
        txtCardNumber.keyboardType = .numberPad
    
        cardExpirationInputController.formatter = cardExpirationFormatter
        txtCardExpiry.delegate = cardExpirationInputController
        txtCardExpiry.text = cardExpirationFormatter.format("")
        txtCardExpiry.keyboardType = .numberPad
    
        cardCVVInputController.formatter = cardCVVFormatter
        txtCardCVV.delegate = cardCVVInputController
        txtCardCVV.text = cardCVVFormatter.format("")
        txtCardCVV.keyboardType = .numberPad

    }
    
    
    @IBAction func btnSubmit(_ sender: Any) {
        btnSubmit.isEnabled = false
        btnSubmit.alpha = 0.5
        self.doSaleTransaction()
    }
    
    @IBAction func nameTextChanged(_ sender: UITextField) {
        onChange()
    }
    
    
    @IBAction func numberTextChanged(_ sender: UITextField) {
        onChange()
        sender.textColor = UIColor.black
        let number = cardNumberFormatter.unformat(sender.text)
    
        if (number?.count == 16){
            if isValidCardNumber(number: number){
                txtCardExpiry.becomeFirstResponder()
            }else{
                //cardView.shake(duration: 1)
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
                //cardView.paymentCardTextFieldDidBeginEditingCVC()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.txtCardCVV.becomeFirstResponder()
                }
            }else{
                //cardView.shake(duration: 1)
                sender.textColor = UIColor.red
            }
        }else if cardCVVFormatter.unformat(sender.text)?.count == 0{
            txtCardNumber.becomeFirstResponder()
        }
    }
    
    
    @IBAction func cvvTextChanged(_ sender: UITextField) {
        onChange()
        sender.textColor = UIColor.black
        if (cardCVVFormatter.unformat(sender.text)?.count == 4){
            sender.resignFirstResponder()
            if isValidCVC(){
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    //self.cardView.paymentCardTextFieldDidEndEditingCVC()
                }
            }else{
                //cardView.shake(duration: 1)
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
        
        //        paymentCardTextFieldDidChange(
        //            cardNumber: number,
        //            expirationYear: expiry.year,
        //            expirationMonth: expiry.month,
        //            cvc: cvv
        //        )
        let unformateNumber = number.replacingOccurrences(of: " ", with: "")
        btnSubmit.isEnabled = isValidExpiry() && isValidCardNumber(number: unformateNumber) && isValidCVC()
        if btnSubmit.isEnabled {
            btnSubmit.alpha = 1.0
        }
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
        return ((number ?? "").count == 15 || (number ?? "").count == 16)
        //return ((number ?? "").count == 15 || (number ?? "").count == 16) || cardView.cardBrand != .NONE
    }
   
    /*
    func isValidExpiry() -> Bool{
        let df = DateFormatter()
        df.locale = Locale.init(identifier: "en-US")
        
        df.dateFormat = "MM"
        let month = df.string(from: Date())
        
        df.dateFormat = "yy"
        let year = df.string(from: Date())
        
        let expiry = cardxExpiry()
        
        if let y1 = expiry.year, let m1 = expiry.month,
           let y2 = UInt(year), let m2 = UInt(month){
            if y1 > y2 { return true }
            if y1 == y2 && m1 >= m2 { return true }
        }
        
        return false
    }
     */
    
    func isValidExpiry() -> Bool {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en-US")
        
        // Get the current month and year
        df.dateFormat = "MM"
        let currentMonth = df.string(from: Date())
        
        df.dateFormat = "yy"
        let currentYear = df.string(from: Date())
        
        // Get the expiry date entered by the user
        let expiry = cardxExpiry()
        
        // Check that the month is within 1 and 12
        guard let m1 = expiry.month, (1...12).contains(m1) else {
            return false
        }
        
        // Continue with the existing year and month validation
        if let y1 = expiry.year, let y2 = UInt(currentYear), let m2 = UInt(currentMonth) {
            if y1 > y2 { return true }
            if y1 == y2 && m1 >= m2 { return true }
        }
        
        return false
    }

    
    func isValidCVC() -> Bool{
        return (txtCardCVV.text?.count == 3 || txtCardCVV.text?.count == 4 )
    }
    
}

extension CardDetailViewController {
    
    
    func setLocalization(langugeCode : EdfaPayLanguage ){
        
        // Set localized text for a UIButton
        setLocalizedText(for: btnSubmit, key: "label_pay", languageCode: langugeCode)
        setLocalizedText(for: lblTotalAmount, key: "label_total", languageCode: langugeCode)
        
            
        if(_designType != .three){
            setLocalizedText(for: lblCardDes, key: "lbl_card_desc", languageCode: langugeCode)
            setLocalizedText(for: lblMonthYear, key: "label_month_year", languageCode: langugeCode)
            setLocalizedText(for: lblValidThru, key: "label_valid_thru", languageCode: langugeCode)
            setLocalizedText(for: lblCvv, key: "label_cvv", languageCode: langugeCode)
        }
        
        setLocalizedText(for: lblCardHolder, key: "label_card_holder_name", languageCode: langugeCode)
        setLocalizedText(for: lblCardnumber, key: "label_card_number", languageCode: langugeCode)
        setLocalizedText(for: cardViewCardNumber, key: "lbl_card_number_placetext", languageCode: langugeCode)
        setLocalizedText(for: lblCvvField, key: "label_cvv", languageCode: langugeCode)
        setLocalizedText(for: lblExpiryField, key: "label_expiry", languageCode: langugeCode)
        setLocalizedText(for: lblPowredBy, key: "lbl_poweredby", languageCode: langugeCode)
        setLocalizedText(for: cardViewCardName, key: "lbl_card_holder_placetext", languageCode: langugeCode)
//        setLocalizedText(for: cardViewCardNumber, key: "lbl_card_number_placetext", languageCode: langugeCode)
    
        adjustLayoutDirection(languageCode: langugeCode)

    }
    
    func setLocalizedText(for component: AnyObject, key: String, languageCode: EdfaPayLanguage = .en) {
        // Get the bundle for the pod
        let podBundle = Bundle(for: EdfaPgSdk.self) // Replace with a class from your pod

        // Find the localization bundle within the pod bundle
        if let localizationBundle = podBundle.path(forResource: languageCode.rawValue, ofType: "lproj"),
           let bundle = Bundle(path: localizationBundle) {
            // Get the localized string
            let localizedString = NSLocalizedString(key, tableName: nil, bundle: bundle, value: "", comment: "")
            //print("Localized String: \(localizedString)")

            // Set the localized text based on the component type
            switch component {
            case let button as UIButton:
                button.setTitle(localizedString, for: .normal)
            case let label as UILabel:
                label.text = localizedString
            case let textField as UITextField:
                textField.text = localizedString
            default:
                print("Unsupported component type")
            }
        } else {
            print("\(languageCode) localization not found")
            // Optionally, set the default text if the localization is not found
            if let button = component as? UIButton {
                button.setTitle(key, for: .normal)
            } else if let label = component as? UILabel {
                label.text = key
            } else if let textField = component as? UITextField {
                textField.placeholder = key
            }
        }
    }
    
    func adjustLayoutDirection(languageCode: EdfaPayLanguage) {
        let direction: UISemanticContentAttribute = languageCode == .ar ? .forceRightToLeft : .forceLeftToRight
        let alignment: NSTextAlignment = languageCode == .ar ? .right : .left

        view.semanticContentAttribute = direction
        
        func applyDirection(to view: UIView) {
            view.semanticContentAttribute = direction
            for subview in view.subviews {
                applyDirection(to: subview)
            }
        }
        
        applyDirection(to: view)
        // Update text alignment
        txtCardCVV.textAlignment = alignment
        txtCardExpiry.textAlignment = alignment
        txtCardNumber.textAlignment = alignment
        txtCardHolderName.textAlignment = alignment
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }

    
}


extension CardDetailViewController : EdfaPgAdapterDelegate{
    func willSendRequest(_ request: EdfaPgDataRequest) {
        
    }
    
    func didReceiveResponse(_ reponse: EdfaPgDataResponse?) {
        
    }
    
    
    func doSaleTransaction(){
        
        
        //        let payerOptions = EdfaPgPayerOptions(middleName: tfPayerMiddleName.text,
        //                                                 birthdate: Foundation.Date.formatter.date(from: tfPayerBirthday.text ?? ""),
        //                                                 address2: tfPayerAddress2.text,
        //                                                 state: tfPayerState.text)
        //        
        //        let payer = EdfaPgPayer(firstName: tfPayerFirstName.text ?? "",
        //                                   lastName: tfPayerLastName.text ?? "",
        //                                   address: tfPayerAddress.text ?? "",
        //                                   country: tfPayerCountryCode.text ?? "",
        //                                   city: tfPayerCity.text ?? "",
        //                                   zip: tfPayerZip.text ?? "",
        //                                   email: tfPayerEmail.text ?? "",
        //                                   phone: tfPayerPhone.text ?? "",
        //                                   ip: tfPayerIpAddress.text ?? "",
        //                                   options: payerOptions)
        //        
        //        let saleOptions = EdfaPgSaleOptions(channelId: tfChannelId.text,
        //                                               recurringInit: swtInitRecurringSale.isOn)
        //        
        //        let transaction = EdfaPgTransactionStorage.Transaction(payerEmail: payer.email,
        //                                                                  cardNumber: card.number)
        
        guard  let number = cardNumberFormatter.unformat(txtCardNumber.text),
               let cvv = cardCVVFormatter.unformat(txtCardCVV.text),
               let expiryYear = cardxExpiry().year,
               let expiryMonth = cardxExpiry().month else {
            return
        }
        
        _cardNumber = number.replacingOccurrences(of: " ", with: "")
        
        
        let _card = EdfaPgCard(
            number: number,
            expireMonth: Int(expiryMonth),
            expireYear: Int(expiryYear + 2000),
            cvv: cvv
        )
        
        
        let saleOptions:EdfaPgSaleOptions? = EdfaPgSaleOptions(channelId: "", recurringInit:_recurring)
        showLoading()
        saleAdapter.execute(order: _order,
                            card: _card,
                            payer: _payer,
                            termUrl3ds: EdfaPgProcessCompleteCallbackUrl,
                            options: saleOptions,
                            auth: _auth) { [weak self] (response) in
            
            hideLoading()
            
            guard let self = self else { return }
            
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
                    _txnId = redirectResult.transactionId
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
                                saleResponse: response,
                                transactionId: txnId
                            )
                        }else{
                            _onTransactionFailure?(
                                response,
                                "Something went wrong (Transaction ID not returned on success response)"
                            )
                        }
                        
                        
                    },
                    onTransactionFailure: { error in
                        print("onTransactionFailure: \(error)")
                        _onTransactionFailure?(response, error)
                        
                    }).enableLogs()
                .show(owner: self, onStartIn: { viewController in
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
                                _onTransactionSuccess?(
                                    saleResponse,
                                    successResult
                                )
                                
                            }else if successResult.status == .pending && _auth{
                                print("Auth Transaction pending: \(successResult)")
                                _onTransactionSuccess?(
                                    saleResponse,
                                    successResult
                                )
                                
                            }else{
                                _onTransactionFailure?(
                                    saleResponse,
                                    successResult
                                )
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


public class EdfaCardPay{
    
    public init() {}
    
    func start() -> CardDetailViewController{
        let vc = CardDetailViewController(
            nibName: getSelectedPaymentScreen(designType: _designType),
            bundle: Bundle(for: CardDetailViewController.self)
        )
        vc.onPresent = _onPresent
        
        if let navigationController = _target as? UINavigationController{
            navigationController.pushViewController(vc, animated: true)
        }else if let viewController = _target{
            viewController.present(vc, animated: true)
        }
        return vc
    }
    
    class public func viewController(target:UIViewController,
                                     payer:EdfaPgPayer,
                                     order:EdfaPgSaleOrder,
                                     recurring:Bool = false,
                                     transactionSuccess:@escaping TransactionCallback,
                                     transactionFailure:@escaping TransactionCallback,
                                     onError:@escaping ErrorCallback,
                                     onPresent:(() ->Void)?) -> UIViewController{
        _target = target
        _payer = payer
        _order = order
        _recurring = recurring
        _onTransactionSuccess = transactionSuccess
        _onTransactionFailure = transactionFailure
        _onError = onError
        _onPresent = onPresent
        
        return CardDetailViewController(
            nibName: "CardDetailViewController",
            bundle: Bundle(for: CardDetailViewController.self)
        )
    }

    public func getSelectedPaymentScreen(designType: EdfaPayDesignType?)->String{
        let defaultScreenName = "CardDetailViewOne"
        if let designType = designType {
                    return designType.screenName
        }
        return defaultScreenName
    }
}


// Payment Properties Setters
extension EdfaCardPay{
    
    public func initialize(target:UIViewController, onError:@escaping ErrorCallback, onPresent:(() ->Void)?) -> UIViewController{
        _target = target
        _onError = onError
        _onPresent = onPresent
        // Validate that payer has been set and is valid
        guard let payer = _payer else {
            onError(["Payer information is missing. Please call 'set(payer:)' before initializing."])
            return UIViewController()
        }
        guard let _ = _order else {
               onError(["Order information is missing. Please call 'set(order:)' before initializing."])
               return UIViewController()
        }

        // Validate payer and order
        let (isPayerValid, payerErrors) = validatePayer()
        let (isOrderValid, orderErrors) = validateOrder()
        let validationErrors = payerErrors + orderErrors
           
        if !isPayerValid || !isOrderValid {
            onError(validationErrors)
            return UIViewController()
        }
        return start()
    }
    
    public func on(transactionSuccess:@escaping TransactionCallback) -> EdfaCardPay{
        _onTransactionSuccess = transactionSuccess
        return self
    }
    
    public func on(transactionFailure:@escaping TransactionCallback) -> EdfaCardPay{
        _onTransactionFailure = transactionFailure
        return self
    }
    
    public func set(payer:EdfaPgPayer) -> EdfaCardPay{
        _payer = payer
        return self
    }
    
    public func set(order:EdfaPgSaleOrder) -> EdfaCardPay{
        _order = order
        return self
    }
    
    public func set(designType:EdfaPayDesignType) -> EdfaCardPay{
       _designType = designType
        return self
    }
    public func set(language:EdfaPayLanguage) -> EdfaCardPay{
        _languageCode = language
        return self
    }
    public func set(recurring:Bool) -> EdfaCardPay{
        _recurring = recurring
        return self
    }
    public func set(auth:Bool) -> EdfaCardPay{
        _auth = auth
        return self
    }
}


// Payment Properties Validator
private extension EdfaCardPay{
    func validate() -> (valid:Bool, validationErrors:[String] ){
        var errors:[String] = []
        var valid = true
        
        
        if _onTransactionSuccess == nil{
            valid = valid && false
            errors
                .append(
                    "onTransactionFailure not set, try to call function 'EdfaApplePay.on(transactionSuccess:)'"
                )
        }
        
        if _onTransactionFailure == nil{
            valid = valid && false
            errors
                .append(
                    "onTransactionFailure not set, try to call function 'EdfaApplePay.on(transactionFailure:)'"
                )
        }
        
        if !(_order.amount >= 1){
            valid = valid && false
            errors
                .append("Missing or invalid amount should be greater than 1.00")
        }
        
        if _order.currency.count != 3{
            valid = valid && false
            errors
                .append(
                    "Missing or invalid currency code (example: 'SAR' for Saudi Riyal)"
                )
        }
        
        if _order.country.count != 2{
            valid = valid && false
            errors
                .append(
                    "Missing or invalid country code (example:'SA' for SaudiArabia)"
                )
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
            errors
                .append(
                    "Missing or invalid email. ([A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64})"
                )
        }
        
        return (valid, errors)
    }
    
    private func validateOrder() -> (Bool, [String]) {
        var errors = [String]()
        var isValid = true
        
        // Check if _order is set
        guard let order = _order else {
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

        if let firstName = _payer?.firstName, firstName.isEmpty {
            isValid = false
            errors.append("Missing or invalid payer first name")
        } else if _payer?.firstName == nil {
            isValid = false
            errors.append("Payer first name is missing")
        }

        if let lastName = _payer?.lastName, lastName.isEmpty {
            isValid = false
            errors.append("Missing or invalid payer last name")
        } else if _payer?.lastName == nil {
            isValid = false
            errors.append("Payer last name is missing")
        }

        if let address = _payer?.address, address.isEmpty {
            isValid = false
            errors.append("Missing or invalid address as payer information")
        } else if _payer?.address == nil {
            isValid = false
            errors.append("Payer address is missing")
        }

        if let country = _payer?.country, country.isEmpty {
            isValid = false
            errors.append("Missing or invalid country as payer information")
        } else if _payer?.country == nil {
            isValid = false
            errors.append("Payer country is missing")
        }

        if let city = _payer?.city, city.isEmpty {
            isValid = false
            errors.append("Missing or invalid city as payer information")
        } else if _payer?.city == nil {
            isValid = false
            errors.append("Payer city is missing")
        }

        if let phone = _payer?.phone, !phone.isPhoneNumber() {
            isValid = false
            errors.append("Missing or invalid phone number. ([0-9٠-٩]{8,})")
        } else if _payer?.phone == nil {
            isValid = false
            errors.append("Payer phone number is missing")
        }

        if let email = _payer?.email, !email.isEmail() {
            isValid = false
            errors.append("Missing or invalid email. ([A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64})")
        } else if _payer?.email == nil {
            isValid = false
            errors.append("Payer email is missing")
        }

        return (isValid, errors)
    }

    
}

extension CardDetailViewController : UITextFieldDelegate {
    
    public func setupTargets(){
        // Add target for text change events
        self.txtCardHolderName
            .addTarget(
                self,
                action: #selector(textFieldDidChange(_:)),
                for: .editingChanged
            )
        self.txtCardCVV
            .addTarget(
                self,
                action: #selector(textFieldDidChange(_:)),
                for: .editingChanged
            )
        self.txtCardExpiry
            .addTarget(
                self,
                action: #selector(textFieldDidChange(_:)),
                for: .editingChanged
            )
        self.txtCardNumber
            .addTarget(
                self,
                action: #selector(textFieldDidChange(_:)),
                for: .editingChanged
            )
    }

    // Method that gets called whenever the text changes in the text field
    @objc func textFieldDidChange(_ textField: UITextField) {
        //formmating data to display on card
        let name = txtCardHolderName.text
        //let number = cardNumberFormatter.format(txtCardNumber.text) ?? ""
        let expiry = cardxExpiry()
        let cvv = cardExpirationFormatter.unformat(txtCardCVV.text)
        let number = getFormatedCardNumber(uiTextField: txtCardNumber.text!)
        let unformateNumber = number.replacingOccurrences(of: " ", with: "")
        //if data entered correct need to enable submit button
        btnSubmit.isEnabled = isValidExpiry() && isValidCardNumber(number: unformateNumber) && isValidCVC()
        if btnSubmit.isEnabled {
            btnSubmit.alpha = 1.0
        }else{
            btnSubmit.isEnabled = false
            btnSubmit.alpha = 0.5
        }
        textField.textColor = UIColor.black
          
          
        // when edit Card Holder Name this code execute
        if textField == txtCardHolderName {
            if (name == "") {
                setLocalizedText(for: self.cardViewCardName, key: "lbl_card_holder_placetext", languageCode: _languageCode)
            }else{
                self.cardViewCardName.text = name
            }
        }
        // when edit Card Expiry this code execute
        else if textField == txtCardExpiry {
            if let expireMonth = expiry.month, let expireYear = expiry.year {
                self.cardViewCardExpiry.text = NSString(format: "%02ld", expireMonth) as String + "/" + (
                    NSString(format: "%02ld", expireYear) as String
                )
            }
            if expiry.month == 0 {
                cardViewCardExpiry.text = "00/00"
            }

            if cardExpirationFormatter.unformat(textField.text)?.count == 4{
                if isValidExpiry(){
                    //cardView.paymentCardTextFieldDidBeginEditingCVC()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.txtCardCVV.becomeFirstResponder()
                    }
                }else{
                    //cardView.shake(duration: 1)
                    textField.textColor = UIColor.red
                }
            }else if cardCVVFormatter.unformat(textField.text)?.count == 0{
                txtCardNumber.becomeFirstResponder()
            }
        }
        // when edit Card Number this code execute
        else if textField == txtCardNumber {
            if number.isEmpty {
                setLocalizedText(for: self.cardViewCardNumber, key: "lbl_card_number_placetext", languageCode: _languageCode)
            }else{
                self.cardViewCardNumber.text = number
            }
            let number = cardNumberFormatter.unformat(textField.text)
            if (number?.count == 16){
                if isValidCardNumber(number: number){
                     txtCardCVV.becomeFirstResponder()
                }else{
                    //cardView.shake(duration: 1)
                    textField.textColor = UIColor.red
                }
            }else if cardCVVFormatter.unformat(textField.text)?.count == 0{
                txtCardHolderName.becomeFirstResponder()
            }
              
        }
        // when edit cvv this code execute
        else if textField == txtCardCVV {
            self.cardViewCvv.text = (cvv?.isEmpty ?? true) ? "000" : cvv
            if (cardCVVFormatter.unformat(textField.text)?.count == 4){
                textField.resignFirstResponder()
                if isValidCVC(){
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        //self.cardView.paymentCardTextFieldDidEndEditingCVC()
                        self.txtCardExpiry.becomeFirstResponder()
                    }
                }else{
                    //cardView.shake(duration: 1)
                    textField.textColor = UIColor.red
                }
            }else if cardCVVFormatter.unformat(textField.text)?.count == 0{
                txtCardExpiry.becomeFirstResponder()
            }
        }
    }
    
    func getFormatedCardNumber(uiTextField: String)-> String{
        // Remove any existing spaces
        let cleanedText = uiTextField.replacingOccurrences(of: " ", with: "")
             
        // Group text in chunks of 4
        var formattedText = ""
        for (index, character) in cleanedText.enumerated() {
            if index != 0 && index % 4 == 0 {
                formattedText += " "
            }
            formattedText.append(character)
        }
        return formattedText;
    }
}
