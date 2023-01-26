//
//  ShortInfoItem.swift
//  CTFeedbackSwift
//
//  Created by Mykhailishyn, Mykola (ADM) on 09.01.2023.
//

import Foundation

struct ShortInfoItem: FeedbackItemProtocol {
    var buildString: String {
        guard let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
            else { return "" }
        return build
    }
    
    var deviceName: String {
        guard let path = Bundle.platformNamesPlistPath,
              let dictionary = NSDictionary(contentsOfFile: path) as? [String: String]
            else { return "" }

        let rawPlatform = platform
        return dictionary[rawPlatform] ?? rawPlatform
    }
    
    var systemVersion: String {
        UIDevice.current.systemVersion
    }
    
    var appName: String {
        if let result = _appName {
            return result
        }
        if let displayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String {
            return displayName
        }
        if let bundleName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
            return bundleName
        }
        return ""
    }
    
    var appVersion: String {
        guard let shortVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
            else { return "" }
        return shortVersion
    }
    
    private var platform: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        guard let machine = withUnsafePointer(to: &systemInfo.machine, {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in
                String.init(validatingUTF8: ptr)
            }
        }) else { return "Unknown" }
        return String(validatingUTF8: machine) ?? "Unknown"
    }

    let isHidden: Bool
    let textColor: UIColor?
    let cognitoId: String?
    private let _appName: String?

    init(isHidden: Bool, textColor: UIColor?, cognitoId: String? = nil, appName: String? = nil) {
        self.isHidden = isHidden
        self.textColor = textColor
        self.cognitoId = cognitoId
        self._appName = appName
    }
}
