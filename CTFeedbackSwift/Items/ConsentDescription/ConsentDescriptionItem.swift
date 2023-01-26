//
//  ConsentDescriptionItem.swift
//  CTFeedbackSwift
//
//  Created by Mykhailishyn, Mykola (ADM) on 06.01.2023.
//

import Foundation

struct ConsentDescriptionItem: FeedbackItemProtocol {
    var title: NSAttributedString {
        var text = CTLocalizedString("CTFeedback.ConsentDescription")
        guard text.contains("<privacy_policy>") else {
            return NSAttributedString(string: "")
        }
        let range = text.index(before: text.index(after: text.range(of:"<privacy_policy>")!.upperBound))..<text.index(after: text.index(before: text.range(of:"</privacy_policy>")!.lowerBound))
        let privacyText = String(text[range])
        
        let termsText = String(text[range])
        text = text
            .replacingOccurrences(of: "<privacy_policy>", with: "")
            .replacingOccurrences(of: "</privacy_policy>", with: "")
        let attributedString = NSMutableAttributedString(string: text)
        let privacyAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.attachment: URL(string: CTLocalizedString("Info_privacypolicy_link"))!,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.foregroundColor: UIColor.blue,
            NSAttributedString.Key.underlineColor: UIColor.blue]
        attributedString.addAttributes(privacyAttributes, range: NSRange(text.range(of: privacyText)!, in: text))
        return attributedString
    }

    let isHidden: Bool
    let textColor: UIColor?

    init(isHidden: Bool, textColor: UIColor?) {
        self.isHidden = isHidden
        self.textColor = textColor
    }
}
