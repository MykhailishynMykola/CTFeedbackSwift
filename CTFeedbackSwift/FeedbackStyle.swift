//
//  FeedbackStyle.swift
//  CTFeedbackSwift
//
//  Created by Mykhailishyn, Mykola (ADM) on 26.01.2023.
//

import UIKit

public struct FeedbackStyle {
    public let tintColor: UIColor
    public let textColor: UIColor
    public let backgroundColor: UIColor
    
    public init(tintColor: UIColor, textColor: UIColor, backgroundColor: UIColor) {
        self.tintColor = tintColor
        self.textColor = textColor
        self.backgroundColor = backgroundColor
    }
}