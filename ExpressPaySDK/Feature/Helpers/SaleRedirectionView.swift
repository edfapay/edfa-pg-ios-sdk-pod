//
//  Redirect3dsVerificationView.swift
//  ExpressPaySDK
//
//  Created by Zohaib Kambrani on 17/01/2023.
//

import Foundation
import UIKit
import WebKit

fileprivate var shouldDismiss:Bool = true

let ExpressPayProcessCompleteCallbackUrl = "https://expresspay.sa/process-completed"
fileprivate var response3ds:ExpressPay3dsResponse?

public class SaleRedirectionView : WKWebView{
    var viewController:Secure3DSVC? = nil
    
    var onLoading:((Bool) -> Void)? = nil
    private var logs:Bool = false
    private var response:ExpressPaySaleRedirect!
    
    private var onStartIn:((UIViewController)->Void)?
    private var onError:((String)->Void)?
    
    private var onTransactionSuccess:((ExpressPay3dsResponse)->Void)?
    private var onTransactionFailure:((ExpressPay3dsResponse)->Void)?
    
    private var sale3dsViewController:Secure3DSVC!

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
    
    public func setup(response:ExpressPaySaleRedirect, onTransactionSuccess:((ExpressPay3dsResponse)->Void)?, onTransactionFailure:((ExpressPay3dsResponse)->Void)?) -> SaleRedirectionView{
        
        self.response = response
        self.onTransactionFailure = onTransactionFailure
        self.onTransactionSuccess = onTransactionSuccess
        
        return self
    }
    
    public func show(owner:UIViewController, onStartIn:@escaping ((UIViewController)->Void), onError:@escaping ((String)->Void)){
        self.onStartIn = onStartIn
        self.onError = onError
        
        if onTransactionSuccess == nil || onTransactionFailure == nil{
            onError("onTransactionSuccess and onTransactionFailure function should be passed to SaleRedirectionView.setup function")
            return
        }
        
        if response.validation() == false{
            onError("Invalid or missing parameters in object 'result:ExpressPaySaleRedirect'")
            return
        }
        
        navigationDelegate = self
        uiDelegate = self
        
        sale3dsViewController = Secure3DSVC.with(content: self, response: response)
        
        if let navigationController  =  owner as? UINavigationController{
            navigationController.pushViewController(sale3dsViewController, animated: true)
            return
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
        
        if url.lowercased().starts(with: ExpressPayProcessCompleteCallbackUrl){
            operationCompleted(
                result: response3ds ?? ExpressPay3dsResponse(
                    orderId: response.orderId, transactionId: response.transactionId,
                    ciphertext: nil, nonce: nil, tag: nil,
                    result: .failure, gatewayRecommendation: .dontProceed
                )
            )
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
    
    private func operationCompleted(result:ExpressPay3dsResponse){
        webViewLoading(false)
        if result.result == .success{
            self.sale3dsViewController.dismiss(animated: true) {
                self.onTransactionSuccess?(result)
            }
        }else if result.result == .failure{
            self.sale3dsViewController.dismiss(animated: true) {
                self.onTransactionFailure?(result)
            }
        }
    }
    
    private func parseHttpBody(httpBody:Data) -> ExpressPay3dsResponse?{
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
            
            let response = try? JSONDecoder().decode(ExpressPay3dsResponse.self, from: jsonData)

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
    var response:ExpressPaySaleRedirect!
    let loading = UIActivityIndicatorView()
    
    
    class func with(content:SaleRedirectionView, response:ExpressPaySaleRedirect) -> Secure3DSVC{
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

