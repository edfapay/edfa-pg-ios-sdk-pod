//
//  ExpressPayBaseAdapter.swift
//  ExpressPaySDK
//
//  Created by ExpressPay(zik) on 15.02.2021.
//

import Foundation

/// The delegate to observe requests and responses
public protocol ExpressPayAdapterDelegate: AnyObject {
    
    /// Will be called before sending the request
    /// - Parameter request: request to send
    func willSendRequest(_ request: ExpressPayDataRequest)
    
    /// Will be called after receiving the response
    /// - Parameter reponse: response from server
    func didReceiveResponse(_ reponse: ExpressPayDataResponse?)
}

/// The base ExpressPay API Adapter.
public class ExpressPayBaseAdapter<Serivce: Encodable> {
    
    private let apiClient = ExpressPayRestApiClient()
    
    /// The delegate to observe requests and responses
    public weak var delegate: ExpressPayAdapterDelegate?
    
    @discardableResult
    func procesedRequest<T: Decodable>(action: ExpressPayAction,
                                       params: Serivce,
                                       callback: @escaping ExpressPayCallback<T>) -> URLSessionDataTask {
        let url = URL(string: ExpressPaySDK.shared.credentials.paymentUrl)!
        
        let request = ExpressPayDataRequest(url: url,
                                           httpMethod: .post,
                                           body: params)
        
        delegate?.willSendRequest(request)
        
        return apiClient.send(request) { [weak self] in
            self?.parseResponse($0, callback: callback)
        }
    }
    
    private func parseResponse<T: Decodable>(_ response: ExpressPayDataResponse, callback: @escaping ExpressPayCallback<T>) {
        if let data = response.data {
            do {
                callback(.error(try JSONDecoder().decode(ExpressPayError.self, from: data)))
           
            } catch {
                do {
                    let a: T = try JSONDecoder().decode(T.self, from: data)
                    callback(.result(a))
                    
                } catch {
                    callback(.failure(error))
                }
            }
            
        } else {
            callback(.failure(response.error ?? NSError(domain: "Server error", code: 0, userInfo: nil)))
        }
        
        delegate?.didReceiveResponse(response)
    }
}
