//
//  EdfaPgBaseAdapter.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 15.02.2021.
//

import Foundation

/// The delegate to observe requests and responses
public protocol EdfaPgAdapterDelegate: AnyObject {
    
    /// Will be called before sending the request
    /// - Parameter request: request to send
    func willSendRequest(_ request: EdfaPgDataRequest)
    
    /// Will be called after receiving the response
    /// - Parameter reponse: response from server
    func didReceiveResponse(_ reponse: EdfaPgDataResponse?)
}

/// The base EdfaPg API Adapter.
public class EdfaPgBaseAdapter<Serivce: Encodable> {
    
    private let apiClient = EdfaPgRestApiClient()
    
    /// The delegate to observe requests and responses
    public weak var delegate: EdfaPgAdapterDelegate?
    
    @discardableResult
    func procesedRequest<T: Decodable>(action: EdfaPgAction,
                                       params: Serivce,
                                       callback: @escaping EdfaPgCallback<T>) -> URLSessionDataTask {
        let url = URL(string: EdfaPgSdk.shared.credentials.paymentUrl)!
        
        let request = EdfaPgDataRequest(url: url,
                                           httpMethod: .post,
                                           body: params)
        
        delegate?.willSendRequest(request)
        
        return apiClient.send(request) { [weak self] in
            self?.parseResponse($0, callback: callback)
        }
    }
    
    private func parseResponse<T: Decodable>(_ response: EdfaPgDataResponse, callback: @escaping EdfaPgCallback<T>) {
        if let data = response.data {
            do {
                callback(.error(try JSONDecoder().decode(EdfaPgError.self, from: data)))
           
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



/// The base EdfaPg API Adapter.
public class EdfaPgVirtualBaseAdapter<Serivce: Encodable> {
    
    private let apiClient = EdfaPgRestApiClient()
    
    /// The delegate to observe requests and responses
    public weak var delegate: EdfaPgAdapterDelegate?
    
    @discardableResult
    func procesedRequest<T: Decodable>(action: EdfaPgAction,
                                       params: Serivce,
                                       callback: @escaping EdfaPgCallback<T>) -> URLSessionDataTask {
//        let url = URL(string: "\(EdfaPgSdk.shared.credentials.paymentUrl)-va")!
        
        let urlstr = EdfaPgSdk.shared.credentials.paymentUrl.replacingOccurrences(of: "payment/post", with: "")
        let url = URL(string: "\(urlstr)applepay/orders/s2s/sale")!
        
        let request = EdfaPgDataRequest(url: url,
                                           httpMethod: .post,
                                           body: params)
        
        delegate?.willSendRequest(request)
        
        return apiClient.send(request) { [weak self] in
            self?.parseResponse($0, callback: callback)
        }
    }
    
    private func parseResponse<T: Decodable>(_ response: EdfaPgDataResponse, callback: @escaping EdfaPgCallback<T>) {
        if let data = response.data {
            do {
                callback(.error(try JSONDecoder().decode(EdfaPgError.self, from: data)))
           
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
