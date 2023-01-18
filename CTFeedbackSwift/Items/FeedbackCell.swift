//
//  FeedbackCell.swift
//  CTFeedbackSwift
//
//  Created by Mykhailishyn, Mykola (ADM) on 17.01.2023.
//

import UIKit

public class FeedbackCell: UITableViewCell {
    var horizontalMargin: CGFloat = 16.0
    
    override public var frame: CGRect {
        get {
            super.frame
        }
        set (newFrame) {
            var frame = newFrame
            frame.origin.x += horizontalMargin
            frame.size.width -= horizontalMargin * 2
            super.frame = frame
        }
    }
}
