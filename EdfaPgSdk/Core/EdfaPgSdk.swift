//
//  EdfaPgSdk.swift
//  EdfaPgSdk
//
//  Created by EdfaPg(zik) on 15.02.2021.
//

import Foundation

/**
 * The initial point of the *EdfaPgSdk*.
 *
 * Before you get an account to access Payment Platform, you must provide the following data to the Payment Platform
 * administrator:
 * IP list - List of your IP addresses, from which requests to Payment Platform will be sent.
 * Notification URL - URL which will be receiving the notifications of the processing results of your request to
 * Payment Platform.
 * Contact email -  Email address of Responsible Person who will monitor transactions, conduct refunds, etc.
 *
 * Note: Notification URL is mandatory if your account supports 3D-Secure. The length of Notification URL should not be
 * more than 255 symbols.
 * With all Payment Platform POST requests at Notification URL the Merchant must return the string "OK" if he
 * successfully received data or return "ERROR".
 *
 * You should get the following information from administrator to begin working with the Payment Platform:
 * *EdfaPgCredential.clientKey* - Unique key to identify the account in Payment Platform
 * (used as request parameter).
 * *EdfaPgCredential.clientPass* - Password for Client authentication in Payment Platform
 * (used for calculating hash parameter).
 * [EdfaPgCredential.paymentUrl] - URL to request the Payment Platform.
 *
 * For the transaction, you must send the server to server HTTPS POST request with fields listed below to Payment
 * Platform URL (*EdfaPgCredential.paymentUrl*). In response Payment Platform will return the JSON  encoded string.
 * If your account supports 3D-Secure and credit card supports 3D-Secure, then Payment Platform will return the link to
 * the 3D-Secure Access Control Server to perform 3D-Secure verification. In this case, you need to redirect the
 * cardholder at this link. If there are also some parameters except the link in the result, you will need to redirect
 * the cardholder at this link together with the parameters using the method of data transmitting indicated in the same
 * result. In the case of 3D-Secure after verification on the side of the 3D-Secure server, the owner of a credit card
 * will come back to your site using the link you specify in the sale request, and Payment Platform will return the
 * result of transaction processing to the Notification URL action.
 *
 * To initialize the *EdfaPgSdk* call one of the following methods: *config*.
 * The initialization can be done programmatically.
 *
 */

/*
 // Could not find module 'EdfaPgSdk' for target 'arm64-apple-ios-simulator'; found: arm64-apple-ios, at: /Volumes/EdfaPay/Codes/Github/EdfaPg/iOS/edfa-pg-ios-sdk-pod/EdfaPgSdk.framework/Modules/EdfaPgSdk.swiftmodule
 
 
 // Archive Framework for Simulator
 xcodebuild archive \
 -scheme EdfaPgSdk \
 -configuration Release \
 -destination 'generic/platform=iOS Simulator' \
 -archivePath './build/EdfaPgSdk.framework-iphonesimulator.xcarchive' \
 SKIP_INSTALL=NO \
 BUILD_LIBRARIES_FOR_DISTRIBUTION=YES
 
 
 // Archive Framework for iOS
 xcodebuild archive \
 -scheme EdfaPgSdk \
 -configuration Release \
 -destination 'generic/platform=iOS' \
 -archivePath './build/EdfaPgSdk.framework-iphoneos.xcarchive' \
 SKIP_INSTALL=NO \
 BUILD_LIBRARIES_FOR_DISTRIBUTION=YES
 
 */

public var ENABLE_DEBUG = false

public final class EdfaPgSdk {
    
    static let shared = EdfaPgSdk()
    
    var credentials: EdfaPgCredential {
        guard let credentials = _credentials else { fatalError("EdfaPgSdk is not configured") }
        
        return credentials
    }
    
    private var _credentials: EdfaPgCredential?
    
    /// This fuction configure *EdfaPgSdk* with your *EdfaPgCredentials* from code
    ///
    /// - Parameter credendials: your credentilans
    /// - Requires: Use this function for configure *EdfaPgSdk* in code
    public static func config(_ credendials: EdfaPgCredential) {
        shared._credentials = credendials
        #if DEBUG
        ENABLE_DEBUG = true
        #endif
    }
    
    public static func enableLogs(){
        ENABLE_DEBUG = true
    }
    
    private init() { }
}
