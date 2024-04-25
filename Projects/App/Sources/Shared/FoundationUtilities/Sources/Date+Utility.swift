//
//  Date+Utility.swift
//  FoundationUtilities
//
//  Created by 김요한 on 2024/03/21.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation

public extension Date {
    enum Format: String {
        case yearToDay = "yyyy.MM.dd"
        case yearToSecond = "yyyy-MM-dd HH:mm:ss"
        case yearToMinute = "yy. MM. dd HH:mm"
        case timeStamp = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        case hourAndMinute = "HH:mm"
        case monthAndDate = "M월 d일"
        case monthAndDate2 = "MM/dd"
        case yearAndMonthAndDate = "YYYY년 M월 d일"
        case yearAndMonth = "YYYY년 M월"
    }
    
    func toStringWithCustomFormat(
        _ format: Format,
        locale: Locale? = .current
    ) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
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
    
    func stringToDate(dateString: String, type: Format) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = type.rawValue
        return formatter.date(from: dateString)
    }
    
    static func fromStringOrNow(_ string: String, ofFormat format: Format = .timeStamp) -> Date {
        let formatter = DateFormatter()
        
        formatter.dateFormat = format.rawValue
        formatter.locale = Locale(identifier: "ko_KR")
        
        if formatter.date(from: string) == nil {
            print("string -> date failed.")
        }
        
        return formatter.date(from: string) ?? Date()
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
