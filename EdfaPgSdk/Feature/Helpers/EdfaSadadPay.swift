//
//  EdfaSadadPay.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 26.12.2025.
//

import Foundation

public class EdfaSadadPay {
    
    public init() {}
    
    private var orderId: String?
    private var orderAmount: Double?
    private var orderDescription: String?
    private var customerName: String?
    private var mobileNumber: String?


    private var onTransactionFailure: ((EdfaPgError?, Error) -> Void)?
    private var onTransactionSuccess: ((EdfaPgSadadSuccess) -> Void)?

    @discardableResult
    public func setOrderId(_ id: String) -> Self {
        orderId = id
        return self
    }
    @discardableResult
    public func setOrderAmount(_ amount: Double) -> Self {
        orderAmount = amount
        return self
    }
    @discardableResult
    public func setOrderDescription(_ description: String) -> Self {
        orderDescription = description
        return self
    }
    @discardableResult
    public func setCustomerName(_ name: String) -> Self {
        customerName = name
        return self
    }
    @discardableResult
    public func setMobileNumber(_ number: String) -> Self {
        mobileNumber = number
        return self
    }
    @discardableResult
    public func onFailure(_ callback: @escaping (EdfaPgError?, Error) -> Void) -> Self {
        onTransactionFailure = callback
        return self
    }
    @discardableResult
    public func onSuccess(_ callback: @escaping (EdfaPgSadadSuccess) -> Void) -> Self {
        onTransactionSuccess = callback
        return self
    }
    public func initialize(onError: @escaping ([String]) -> Void) {
        let errors = validate()
        if errors.isEmpty {
            begin()
        } else {
            onError(errors)
        }
    }
    private func begin() {
        guard let orderId = orderId,
              let orderAmount = orderAmount,
              let orderDescription = orderDescription,
              let customerName = customerName,
              let mobileNumber = mobileNumber else {
            onTransactionFailure?(nil, NSError(domain: "EdfaSadadPay", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing parameters"]))
            return
        }
        let adapter = EdfaPgSadadAdapter()
        adapter.execute(
            orderId: orderId,
            orderAmount: orderAmount,
            orderDescription: orderDescription,
            customerName: customerName,
            mobileNumber: mobileNumber
        ) { result in
    
            switch result {
            case .result(let success):
                self.onTransactionSuccess?(success.result)
            case .failure(let error):
                self.onTransactionFailure?(nil, error)
            case .error(let pgError):
                self.onTransactionFailure?(pgError, NSError(domain: "EdfaSadadPay", code: -2, userInfo: [NSLocalizedDescriptionKey: pgError.localizedDescription]))
            }
        }
    }
    private func validate() -> [String] {
        var errors: [String] = []
        if orderAmount == nil {
            errors.append("orderAmount is empty")
        }
        if (orderId ?? "").isEmpty {
            errors.append("orderId is empty")
        }
        if (orderDescription ?? "").isEmpty {
            errors.append("orderDescription is empty")
        }
        if (customerName ?? "").isEmpty {
            errors.append("customerName is empty")
        }
        if (mobileNumber ?? "").isEmpty {
            errors.append("mobileNumber is empty")
        }
        return errors
    }
}
