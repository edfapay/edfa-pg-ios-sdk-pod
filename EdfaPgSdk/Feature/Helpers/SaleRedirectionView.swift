//
//  Redirect3dsVerificationView.swift
//  EdfaPgSdk
//
//  Created by Zohaib Kambrani on 17/01/2023.
//

import Foundation
import UIKit
import WebKit

fileprivate var shouldDismiss:Bool = true

var EdfaPgProcessCompleteCallbackUrl = "https://edfapay.com/process-completed"
fileprivate var response3ds:EdfaPg3dsResponse?


public class SaleRedirectionView : WKWebView{
    
    
    var onLoading:((Bool) -> Void)? = nil
    private var logs:Bool = false
    private var saleData:SaleTransactionData!
    
    private var onStartIn:((UIViewController)->Void)?
    private var onError:((String)->Void)?
    
    private var callback:EdfaPgGetTransactionDetailsCallback? = nil
    
    private var sale3dsViewController:Secure3DSVC!
    
    
    private lazy var getTransactionDetailAdapter: EdfaPgGetTransactionDetailsAdapter = {
        let adapter = EdfaPgAdapterFactory().createGetTransactionDetails()
        adapter.delegate = self
        return adapter
    }()

    override init(frame: CGRect, configuration:WKWebViewConfiguration) {
        super.init(frame: frame, configuration:configuration)
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    public override func layoutSubviews() {
        setupView()
    }
    
    
    private func setupView() {
        onStartIn?(sale3dsViewController)
    }
    
    public func setup(saleData:SaleTransactionData, callback:@escaping EdfaPgGetTransactionDetailsCallback) -> SaleRedirectionView{
        self.saleData = saleData
        self.callback = callback
        return self
    }
    
    public func show(owner:UIViewController, onStartIn:@escaping ((UIViewController)->Void), onError:@escaping ((String)->Void)){
        self.onStartIn = onStartIn
        self.onError = onError
        
        if callback == nil {
            onError("callback function should be passed to SaleRedirectionView.setup function")
            return
        }
        
        if saleData.redirection.validation() == false{
            onError("Invalid or missing parameters in object 'result:EdfaPgSaleRedirect'")
            return
        }
        
        navigationDelegate = self
        uiDelegate = self
        
        sale3dsViewController = Secure3DSVC.with(content: self, response: saleData.redirection)
        
        if let navigationController  =  owner as? UINavigationController{
            navigationController.pushViewController(sale3dsViewController, animated: true)
            return
        }
        



        if #available(iOS 13.0, *) {
            sale3dsViewController.modalPresentationStyle = .automatic
            sale3dsViewController.isModalInPresentation = false

        } else {
            sale3dsViewController.modalPresentationStyle = .fullScreen
        }

        owner.present(sale3dsViewController, animated: true)
                
    }
    
    public func enableLogs() -> SaleRedirectionView{
        logs = true
        return self
    }
    
    public func disableLogs() -> SaleRedirectionView{
        logs = false
        return self
    }
    
    private func webViewLoading(_ loading:Bool){
        onLoading?(loading)
    }
    
}

extension SaleRedirectionView : EdfaPgAdapterDelegate{
    public func willSendRequest(_ request: EdfaPgDataRequest) {
        
    }
    
    public func didReceiveResponse(_ reponse: EdfaPgDataResponse?) {
        
    }
}

extension SaleRedirectionView : WKNavigationDelegate{
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print(webView)
        
        let url = navigationAction.request.url?.description ?? ""
        _ = String(data: navigationAction.request.httpBody ?? Data(), encoding: .utf8)  ?? "None"
        
        logRequest(request: navigationAction.request)
    
        if url.lowercased().starts(with: "https://pay.expresspay.sa/interaction/"){
            
        }
    
        if url.lowercased().contains("callbackinterface"){
            webViewLoading(true)
        }
        
        if url.lowercased().starts(with: "https://api.expresspay.sa/verify/"),
           let body = navigationAction.request.httpBody{
            if let params = parseHttpBody(httpBody: body){
                if params.result != nil{
                    response3ds = params
                }
            }
        }
        
        if url.lowercased().starts(with: EdfaPgProcessCompleteCallbackUrl){
            checkTransactionStatus()
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
    
    private func checkTransactionStatus(){
        let transactionId = saleData.redirection.transactionId
        let payerEmail = saleData.payer.email
        let cardNumber = saleData.card.number
    
        print(
            "Checking transaction status for transaction id: \(transactionId)"
        )
        getTransactionDetailAdapter.execute(
            transactionId: transactionId,
            payerEmail: payerEmail,
            cardNumber: cardNumber,
            callback: handleStatus
        )
    }
    
    
    private func handleStatus(status:EdfaPgResponse<EdfaPgGetTransactionDetailsResult>){
        delayAndDismiss{
            self.callback?(status)
        }
        
        switch status {
        case .result(let result):
            switch result {
            case .success(let successResult):
                if successResult.status == .settled{
                    print("Transaction settled: \(successResult)")
                    showSuccessAnimation()
                    
                }else if successResult.status == .pending && saleData.auth{
                    print("Auth Transaction pending: \(successResult)")
                    showSuccessAnimation()
                    
                }else{
                    showFailureAnimation()
                }
            }
                            
        case .error(let errorResult):
            debugPrint(errorResult)
            showFailureAnimation()
            
        case .failure(let errorResult):
            debugPrint(errorResult)
            showFailureAnimation()
            
        }
        
    }
    
    private func delayAndDismiss(completion:@escaping () -> Void){
        let millis = EdfaPgSdk.animationDelay ?? 3000
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Int(millis))) {
            self.sale3dsViewController?.dismiss(animated: true, completion: completion)
        }
    }
    
    private func showSuccessAnimation(){
        if let animation = EdfaPgSdk.successAnimation,
            let url = URL(string: animation),
            let request = try? URLRequest(url:url){
            load(request)
        }
    }
    
    private func showFailureAnimation(){
        if let animation = EdfaPgSdk.failureAnimation,
           let url = URL(string: animation),
           let request = try? URLRequest(url:url){
            load(request)
        }
    
    }
    
    private func parseHttpBody(httpBody:Data) -> EdfaPg3dsResponse?{
        var dictionary:[String:String] = [:]
        
        if let bodyString = String(data: httpBody, encoding: .utf8){
            
            bodyString.components(separatedBy: "&")
                .forEach { i in
                    let keyValue = i.components(separatedBy: "=")
                    if keyValue.count == 2,
                       let key  = keyValue.first,
                       let value  = keyValue.last{
                        dictionary[key] = value
                    }
            }
        }
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: dictionary){
            
            let response = try? JSONDecoder().decode(EdfaPg3dsResponse.self, from: jsonData)

            return response
            
        }
    
        return nil
    }
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        webViewLoading(true)
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webViewLoading(false)
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        webViewLoading(false)
    }
}


extension SaleRedirectionView{
    private func logRequest(request:URLRequest){
        if logs == false{
            return
        }
        
        
        let url = request.url?.description ?? ""
        let body = String(data: request.httpBody ?? Data(), encoding: .utf8)  ?? "None"
        
        if logs{
            debugPrint("------------------------------------------------------------------------------------------------------------------------------")
            debugPrint("3DS Verification Redirection")
            debugPrint("------------------------------------------------------------------------------------------------------------------------------")
            debugPrint("URL: \(url)")
            debugPrint("Params: \(body)")
            debugPrint("------------------------------------------------------------------------------------------------------------------------------")
            print("\n\n\n\n\n\n")
        }
    }
}

extension SaleRedirectionView : WKUIDelegate{
    
}


final class Secure3DSVC : UIViewController{
    var content:SaleRedirectionView?
    var response:EdfaPgSaleRedirect!
    let loading = UIActivityIndicatorView()
    
    
    class func with(content:SaleRedirectionView, response:EdfaPgSaleRedirect) -> Secure3DSVC{
        let vc = Secure3DSVC()
        vc.content = content
        vc.response = response
        return vc
    }
    
    override func viewDidLoad() {
        if #available(iOS 13.0, *) {
            isModalInPresentation = true
        } else {
            // Fallback on earlier versions
        }

        response3ds = nil
        
        content?.fixInView(view, margin: 20)
        loading.fixInView(view, margin: 0)
        
        loading.startAnimating()
        loading.tintColor = UIColor.black
        if #available(iOS 13.0, *) {
            loading.style = .large
        } else {
            loading.style = .whiteLarge
            
        }
        
        // prepare json data
        let json: [String: Any] = ["body": response.redirectParams.body ?? ""]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

//        var request = URLRequest(url: URL(string: "https://google.com")!)
        var request = URLRequest(url: URL(string: response.redirectUrl)!)
        request.httpMethod = response.redirectMethod.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        content?.load(request)
        
        content?.onLoading = loading
        
        content?.scrollView.showsVerticalScrollIndicator = false
        content?.scrollView.showsHorizontalScrollIndicator = false
    }
    
    func loading(isLoading:Bool){
        if isLoading == false{
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { timer in
                self.loading.stopAnimating()
                timer.invalidate()
            }
            
        }else{
            self.loading.startAnimating()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
}



public class SaleTransactionData{
    public var auth:Bool
    public var order:EdfaPgSaleOrder
    public var payer:EdfaPgPayer
    public var card:EdfaPgCard
    public var redirection:EdfaPgSaleRedirect
    
    public init(auth:Bool, order: EdfaPgSaleOrder, payer: EdfaPgPayer, card: EdfaPgCard, saleResponse: EdfaPgSaleRedirect) {
        self.auth = auth
        self.order = order
        self.payer = payer
        self.card = card
        self.redirection = saleResponse
    }
}
