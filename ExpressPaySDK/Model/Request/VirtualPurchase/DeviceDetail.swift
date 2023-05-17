//
//  DeviceDetail.swift
//  ExpressPaySDK
//
//  Created by Zohaib Kambrani on 26/01/2023.
//

import Foundation
import UIKit
class DeviceDetail{
    
    func json() -> [String:Any]{
        return [
            "colorDepth": 0,
            "javaEnabled": false,
            "javaScriptEnabled": false,
            "language": "en_US", //"\(Locale.current.language.languageCode?.identifier)_\(Locale.current.language.region?.identifier)",
            "screenHeight": UIScreen.main.bounds.height,
            "screenWidth": UIScreen.main.bounds.width,
            "timeZoneOffset": 0 - (TimeZone.current.secondsFromGMT()/60),
            "userAgent": UserAgent().UAString(),
            "platform": UIDevice.current.model
        ]
    }
}
