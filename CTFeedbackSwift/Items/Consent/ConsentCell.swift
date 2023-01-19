//
//  ConsentCell.swift
//  CTFeedbackSwift
//
//  Created by Mykhailishyn, Mykola (ADM) on 06.01.2023.
//

import UIKit

protocol ConsentCellEventProtocol {
    func toggleConsent(type: ConsentItemType, to enabled: Bool)
}

final class ConsentCell: FeedbackCell {
    private var item: ConsentItem! {
        didSet {
            if let tintColor = item.tintColor {
                consentSwitch.onTintColor = tintColor
            }
            consentSwitchLabel.text = item.type.title
        }
    }
    private var eventHandler: ConsentCellEventProtocol!
    
    private let consentSwitch = UISwitch()
    private let consentSwitchLabel = UILabel()
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        consentSwitchLabel.numberOfLines = 0
        consentSwitchLabel.font = .systemFont(ofSize: 15)
        consentSwitchLabel.setContentCompressionResistancePriority(.init(rawValue: 250), for: .horizontal)
        consentSwitchLabel.minimumScaleFactor = 0.8
        consentSwitchLabel.adjustsFontSizeToFitWidth = true
        
        consentSwitch.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(consentSwitch)
    
        consentSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        consentSwitch.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        
        consentSwitchLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(consentSwitchLabel)
        
        consentSwitchLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        contentView.bottomAnchor.constraint(equalTo: consentSwitchLabel.bottomAnchor, constant: 12).isActive = true
        consentSwitchLabel.leadingAnchor.constraint(equalTo: consentSwitch.trailingAnchor, constant: 12).isActive = true
        contentView.trailingAnchor.constraint(equalTo: consentSwitchLabel.trailingAnchor, constant: 12).isActive = true
        
        consentSwitch.addTarget(self, action: #selector(consentSwitchToggled), for: .valueChanged)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc private func consentSwitchToggled(_ sender: UISwitch) {
        eventHandler.toggleConsent(type: item.type, to: sender.isOn)
    }
}

extension ConsentCell: CellFactoryProtocol {
    class func configure(_ cell: ConsentCell,
                         with item: ConsentItem,
                         for indexPath: IndexPath,
                         eventHandler: ConsentCellEventProtocol) {
        cell.item = item
        cell.eventHandler = eventHandler
        cell.selectionStyle = .none
    }
}
