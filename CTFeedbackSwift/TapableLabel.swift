//
//  TapableLabel.swift
//  CTFeedbackSwift
//
//  Created by Mykhailishyn, Mykola (ADM) on 09.01.2023.
//

import UIKit

protocol TapableLabelDelegate: NSObjectProtocol {
    func tapableLabel(_ label: TapableLabel, didTapUrl url: String, withText text: String, atRange range: NSRange)
}

final class TapableLabel: UILabel {
    private var links: [String: NSRange] = [:]
    private(set) var layoutManager = NSLayoutManager()
    private(set) var textContainer = NSTextContainer(size: .zero)
    private(set) var textStorage = NSTextStorage() {
        didSet {
            textStorage.addLayoutManager(layoutManager)
        }
    }

    weak var delegate: TapableLabelDelegate?

    override var attributedText: NSAttributedString? {
        didSet {
            if let attributedText = attributedText {
                textStorage = NSTextStorage(attributedString: attributedText)
                findLinksAndRange(attributeString: attributedText)
            } else {
                textStorage = NSTextStorage()
                links = [:]
            }
        }
    }

    override var lineBreakMode: NSLineBreakMode {
        didSet {
            textContainer.lineBreakMode = lineBreakMode
        }
    }

    override var numberOfLines: Int {
        didSet {
            textContainer.maximumNumberOfLines = numberOfLines
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        isUserInteractionEnabled = true
        layoutManager.addTextContainer(textContainer)
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = lineBreakMode
        textContainer.maximumNumberOfLines  = numberOfLines
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        textContainer.size = bounds.size
    }

    private func findLinksAndRange(attributeString: NSAttributedString) {
        links = [:]
        attributeString.enumerateAttribute(.attachment, in: NSRange(0..<attributeString.length), options: [.longestEffectiveRangeNotRequired], using: { value, range, stop in
            if let val = value {
                let stringValue = "\(val)"
                self.links[stringValue] = range
            }
        })
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let locationOfTouch = touches.first?.location(in: self) else {
            return
        }
        textContainer.size = bounds.size
        
        // account for text alignment and insets
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        var alignmentOffset: CGFloat
        switch textAlignment {
            case .left, .natural, .justified:
                alignmentOffset = 0.0
            case .center:
                alignmentOffset = 0.5
            case .right:
                alignmentOffset = 1.0
            @unknown default:
                alignmentOffset = 0.5
        }
        let xOffset = ((bounds.size.width - textBoundingBox.size.width) * alignmentOffset) - textBoundingBox.origin.x
        let yOffset = ((bounds.size.height - textBoundingBox.size.height) * alignmentOffset) - textBoundingBox.origin.y
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouch.x - xOffset, y: locationOfTouch.y - yOffset)

        // figure out which character was tapped
        // different solutions for different break types, consider this
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        for (urlString, range) in links where NSLocationInRange(indexOfCharacter, range) {
            let swiftRange = Range(range, in: attributedText!.string)!
            delegate?.tapableLabel(self, didTapUrl: urlString, withText: String(attributedText!.string[swiftRange]), atRange: range)
            return
        }
    }
}
