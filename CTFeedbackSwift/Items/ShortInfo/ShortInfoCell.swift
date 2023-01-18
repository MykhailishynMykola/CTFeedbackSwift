//
//  ShortInfoCell.swift
//  CTFeedbackSwift
//
//  Created by Mykhailishyn, Mykola (ADM) on 09.01.2023.
//

import UIKit

final class ShortInfoCell: FeedbackCell {
    private let titleLabel = UILabel()
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.numberOfLines = 0
        titleLabel.font = .systemFont(ofSize: 15)
        titleLabel.setContentCompressionResistancePriority(.init(rawValue: 250), for: .horizontal)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        contentView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        contentView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 12).isActive = true
    }

    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
}

extension ShortInfoCell: CellFactoryProtocol {
    class func configure(_ cell: ShortInfoCell,
                         with item: ShortInfoItem,
                         for indexPath: IndexPath,
                         eventHandler: Any?) {
        let device = "\(CTLocalizedString("CTFeedback.Device")): \(item.deviceName)"
        
        #if targetEnvironment(macCatalyst)
        let systemVersion = "macOS: \(item.systemVersion)"
        #else
        let systemVersion = "\(CTLocalizedString("CTFeedback.iOS")): \(item.systemVersion)"
        #endif
        
        let appName = "\(CTLocalizedString("CTFeedback.Name")): \(item.appName)"
        let appVersion = "\(CTLocalizedString("CTFeedback.Version")): \(item.appVersion)"
        let build = "\(CTLocalizedString("CTFeedback.Build")): \(item.buildString)"
        let userId = "Id: \(item.cognitoId ?? "-1")"
        
        cell.titleLabel.text = "\(device), \(systemVersion), \(appName), \(appVersion), \(build), \(userId)"
        cell.selectionStyle = .none
    }
}
