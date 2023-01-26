//
//  ConsentItem.swift
//  CTFeedbackSwift
//
//  Created by Mykhailishyn, Mykola (ADM) on 06.01.2023.
//

import Foundation
import UIKit

public enum ConsentItemType {
    case toBeContacted
    case storageAndProcessing
    
    var title: String {
        switch self {
        case .toBeContacted:
            return CTLocalizedString("CTFeedback.TopConsent")
        case .storageAndProcessing:
            return CTLocalizedString("CTFeedback.BottomConsent")
        }
    }
}

public struct ConsentItem: FeedbackItemProtocol {
    public var type: ConsentItemType
    public var isHidden: Bool
    public var tintColor: UIColor?
    public let textColor: UIColor?
}
