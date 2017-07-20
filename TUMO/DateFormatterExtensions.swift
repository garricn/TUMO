//
//  Copyright © 2017 Farmers Insurance Group. All rights reserved.
//

import Foundation

extension DateFormatter {
    /**
     Returns a string representation of a given date formatted using the receiver’s current settings with `en_US_POSIX`
     locale and `GMT` time zone.
     - note: Returns an empty string for an invalid format.
     - parameter date: the Date from which to format the return string
     - parameter format: the DateFormat to use for the return string
     */
    static func string(from date: Date, with format: DateFormat) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX") // FIXME: Use Locale.current instead.
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = format.rawValue
        return formatter.string(from: date)
    }

    /**
     Returns a date from a given date-formatted string and DateFormat with `en_US_POSIX` locale and `GMT` time zone.
     - note: Returns nil if a date cannot be constructed from the given string.
     - parameter string: a date-formatted string
     - parameter format: the DateFormat of the given string
     */
    static func date(from string: String, with format: DateFormat) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX") // FIXME: Use Locale.current instead.
        formatter.dateFormat = format.rawValue
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        let date = formatter.date(from: string)
        return date
    }
}
