//
// Created by 和泉田 領一 on 2017/09/24.
// Copyright (c) 2017 CAPH TECH. All rights reserved.
//

import Foundation

struct UserEmailItem: FeedbackItemProtocol {
    let isHidden: Bool
    let textColor: UIColor?
    var email: String? = .none

    init(isHidden: Bool, textColor: UIColor?) {
        self.isHidden = isHidden
        self.textColor = textColor
    }
}
