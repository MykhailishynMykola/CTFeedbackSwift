//
//  ConsentDescriptionCell.swift
//  CTFeedbackSwift
//
//  Created by Mykhailishyn, Mykola (ADM) on 06.01.2023.
//

import UIKit

protocol ConsentDescriptionCellEventProtocol {
    func showPrivacyPolicy()
}

class ConsentDescriptionCell: FeedbackCell {
    private var item: ConsentDescriptionItem! {
        didSet {
            consentLabel.attributedText = item.title
            consentLabel.textColor = item.textColor
        }
    }
    private var eventHandler: ConsentDescriptionCellEventProtocol!
    private let consentLabel = TapableLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        consentLabel.isUserInteractionEnabled = true
        consentLabel.delegate = self
        consentLabel.numberOfLines = 0
        consentLabel.font = .systemFont(ofSize: 12)
        consentLabel.setContentCompressionResistancePriority(.init(rawValue: 250), for: .horizontal)
        consentLabel.minimumScaleFactor = 0.8
        consentLabel.adjustsFontSizeToFitWidth = true
        
        consentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(consentLabel)
        
        consentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        contentView.bottomAnchor.constraint(equalTo: consentLabel.bottomAnchor, constant: 12).isActive = true
        consentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        contentView.trailingAnchor.constraint(equalTo: consentLabel.trailingAnchor, constant: 12).isActive = true
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension ConsentDescriptionCell: TapableLabelDelegate {
    func tapableLabel(_ label: TapableLabel, didTapUrl url: String, withText text: String, atRange range: NSRange) {
        eventHandler.showPrivacyPolicy()
    }
}

extension ConsentDescriptionCell: CellFactoryProtocol {
    class func configure(_ cell: ConsentDescriptionCell,
                         with item: ConsentDescriptionItem,
                         for indexPath: IndexPath,
                         eventHandler: ConsentDescriptionCellEventProtocol) {
        cell.item = item
        cell.eventHandler = eventHandler
        cell.selectionStyle = .none
    }
}
