//
//  DesignType.swift
//  EdfaPgSdk
//
//  Created by ZIK on 20/01/2025.
//

import Foundation



public enum EdfaPayDesignType : CaseIterable{
    case one
    case two
    case three

    var screenName: String {
        switch self {
        case .one:
            return "CardDetailViewOne"
        case .two:
            return "CardDetailViewTwo"
        case .three:
            return "CardDetailViewThree"
        }
    }
}
