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
        }
    }
    private var eventHandler: ConsentDescriptionCellEventProtocol!
    private let consentLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        consentLabel.isUserInteractionEnabled = true
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
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(consentLabelPressed(_:)))
        consentLabel.addGestureRecognizer(gestureRecognizer)
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc private func consentLabelPressed(_ sender: Any) {
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
