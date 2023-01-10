//
// Created by 和泉田 領一 on 2017/09/07.
// Copyright (c) 2017 CAPH TECH. All rights reserved.
//

import Foundation
import UIKit

public class FeedbackConfiguration {
    public var subject:                     String?
    public var additionalDiagnosticContent: String?
    public var toRecipients:                [String]
    public var ccRecipients:                [String]
    public var bccRecipients:               [String]
    public var usesHTML:                    Bool
    public var dataSource:                  FeedbackItemsDataSource
    public var useCustomTopicPicker:        Bool

    /*
    If topics array contains no topics, topics cell is hidden.
    */
    public init(subject: String? = .none,
                additionalDiagnosticContent: String? = .none,
                topics: [TopicProtocol] = TopicItem.defaultTopics,
                toRecipients: [String],
                ccRecipients: [String] = [],
                bccRecipients: [String] = [],
                hidesUserEmailCell: Bool = true,
                hidesAttachmentCell: Bool = false,
                hidesDeviceInfoSection: Bool = false,
                hidesAppInfoSection: Bool = false,
                hidesShortInfoSection: Bool = false,
                tintColor: UIColor? = nil,
                usesHTML: Bool = false,
                appName: String? = nil,
                cognitoId: String? = nil,
                useCustomTopicPicker: Bool = false) {
        self.subject = subject
        self.additionalDiagnosticContent = additionalDiagnosticContent
        self.toRecipients = toRecipients
        self.ccRecipients = ccRecipients
        self.bccRecipients = bccRecipients
        self.usesHTML = usesHTML
        self.useCustomTopicPicker = useCustomTopicPicker
        self.dataSource = FeedbackItemsDataSource(topics: topics,
                                                  hidesUserEmailCell: hidesUserEmailCell,
                                                  hidesAttachmentCell: hidesAttachmentCell,
                                                  hidesDeviceInfoSection: hidesDeviceInfoSection,
                                                  hidesAppInfoSection: hidesAppInfoSection,
                                                  hidesShortInfoSection: hidesShortInfoSection,
                                                  tintColor: tintColor,
                                                  appName: appName,
                                                  cognitoId: cognitoId)
    }
}
