//
//  Date+Utility.swift
//  FoundationUtilities
//
//  Created by 김요한 on 2024/03/21.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation

public extension Date {
    func toStringWithCustomFormat(
        _ format: String,
        locale: Locale? = .current
    ) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        if let locale {
            formatter.locale = locale
            formatter.timeZone = .init(identifier: "Asia/Seoul")
        }
        return formatter.string(from: self)
    }
    
    func localizedDate() -> Date {
        let timezone = TimeZone.autoupdatingCurrent
        let secondsFromGMT = timezone.secondsFromGMT(for: self)
        let localizedDate = self.addingTimeInterval(TimeInterval(secondsFromGMT))
        return localizedDate
    }
}

public extension String {
    func toDateWithCustomFormat(
        _ format: String,
        locale: Locale? = .current
    ) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        if let locale {
            formatter.locale = locale
            formatter.timeZone = .init(identifier: "Asia/Seoul")
        }
        return formatter.date(from: self) ?? .init()
    }
}
