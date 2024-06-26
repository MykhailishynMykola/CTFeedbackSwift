//
//  DeviceNameCell.swift
//  CTFeedbackSwift
//
//  Created by 和泉田 領一 on 2017/09/24.
//  Copyright © 2017 CAPH TECH. All rights reserved.
//

import UIKit

class DeviceNameCell: FeedbackCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
}

extension DeviceNameCell: CellFactoryProtocol {
    static let reuseIdentifier: String = "DeviceNameCell"

    static func configure(_ cell: DeviceNameCell,
                         with item: DeviceNameItem,
                         for indexPath: IndexPath,
                         eventHandler: Any?) {
        cell.textLabel?.text = CTLocalizedString("CTFeedback.Device")
        cell.textLabel?.textColor = item.textColor
        cell.detailTextLabel?.text = item.deviceName
        cell.selectionStyle = .none
    }
}
