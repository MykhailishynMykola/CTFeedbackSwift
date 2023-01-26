//
// Created by 和泉田 領一 on 2017/09/07.
// Copyright (c) 2017 CAPH TECH. All rights reserved.
//

import UIKit

final public class TopicCell: FeedbackCell {
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: TopicCell.reuseIdentifier)
    }

    public required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
}

extension TopicCell: CellFactoryProtocol {
    static func configure(_ cell: TopicCell,
                          with item: TopicItem,
                          for indexPath: IndexPath,
                          eventHandler: Any?) {
        cell.textLabel?.text = CTLocalizedString("CTFeedback.Topic")
        cell.textLabel?.textColor = item.textColor
        cell.detailTextLabel?.text = item.topicTitle
        cell.detailTextLabel?.textColor = item.textColor
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
    }
}
