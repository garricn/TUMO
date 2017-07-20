//
//  Copyright © 2017 Farmers Insurance Group. All rights reserved.
//

/**
 This enum represents the different valid date formats used throughout the application.
 */
enum DateFormat: String {

    // swiftlint:disable identifier_name

    /// Minute numeric form.
    ///
    ///     Date  : January 5, 2017, 12:34 AM
    ///     Format: mm
    ///     Result: 34
    case mm

    /// Year numeric form.
    ///
    ///     Date  : January 5, 2017, 12:34 AM
    ///     Format: yy
    ///     Result: 17
    case yy

    /// Month numeric form.
    ///
    ///     Date  : January 5, 2017, 12:34 AM
    ///     Format: MM
    ///     Result: 01
    case MM

    /// Full numeric year.
    ///
    ///     Date  : January 5, 2017, 12:34 AM
    ///     Format: yyyy
    ///     Result: 2017
    case yyyy

    /// Month full form.
    ///
    ///     Date  : January 5, 2017, 12:34 AM
    ///     Format: MMMM
    ///     Result: January
    case MMMM

    /// Full locale-specific abbreviated month with 1-digit numeric day.
    ///
    ///     Date  : January 5, 2017, 12:34 AM
    ///     Format: LLL d
    ///     Result: Jan 5
    case LLLd = "LLL d"

    /// Abbreviated month with 2-digit numeric day.
    ///
    ///     Date  : January 5, 2017, 12:34 AM
    ///     Format: MMM dd
    ///     Result: Jan 05
    case MMMdd = "MMM dd"

    /// Slash separated numeric month with full numeric year.
    ///
    ///     Date  : January 5, 2017, 12:34 AM
    ///     Format: MM/yyyy
    ///     Result: 01/2017
    case MMyyyy = "MM/yyyy"

    /// Numeric month space-separated with full numeric year.
    ///
    ///     Date  : January 5, 2017, 12:34 AM
    ///     Format: MM yyyy
    ///     Result: 01 2017
    case MM_yyyy = "MM yyyy"

    /// Abbreviated month dot-space-separate with 2-digit day.
    ///
    ///     Date  : January 5, 2017, 12:34 AM
    ///     Format: MMM. dd
    ///     Result: Jan. 05
    case MMMdotdd = "MMM. dd"

    /// Slash separated numeric-month, 2-digit-day, and full numeric year.
    ///
    ///     Date  : January 5, 2017, 12:34 AM
    ///     Format: MM/dd/yyyy
    ///     Result: 01/05/2017
    case MMddyyyy = "MM/dd/yyyy"

    /// Dash separated full numeric year, 2-digit-day, and numeric-month.
    ///
    ///     Date  : January 5, 2017, 12:34 AM
    ///     Format: yyyy-dd-MM
    ///     Result: 2017-05-01
    case yyyyddMM = "yyyy-dd-MM"

    /// Dash separated full numeric year, numeric-month, and 2-digit-day.
    ///
    ///     Date  : January 5, 2017, 12:34 AM
    ///     Format: yyyy-MM-dd
    ///     Result: 2017-01-05
    case yyyyMMdd = "yyyy-MM-dd"

    /// Dash separated numeric-month, 2-digit-day, and full numeric year.
    ///
    ///     Date  : January 5, 2017, 12:34 AM
    ///     Format: MM-dd-yyyy
    ///     Result: 01/05/2017
    case MMddYYYY = "MM-dd-yyyy"

    /// 1-digit day with locale-specific full month and full numeric year.
    ///
    ///     Date  : January 5, 2017, 12:34 AM
    ///     Format: d LLLL yyyy
    ///     Result: 5 January 2017
    case dLLLLyyyy = "d LLLL yyyy"

    /// Abbreviated month, 2-digit day and full numeric year.
    ///
    ///     Date  : January 5, 2017, 12:34 AM
    ///     Format: MMM dd, yyyy
    ///     Result: Jan 05, 2017
    case MMMddyyyy = "MMM dd, yyyy"

    /// Full month, 2-digit day and full numeric year.
    ///
    ///     Date  : January 5, 2017, 12:34 AM
    ///     Format: MMMM dd, yyyy
    ///     Result: January 05, 2017
    case MMMMddyyyy = "MMMM dd, yyyy"

    /// Full numeric date.
    ///
    ///     Date  : January 5, 2017, 12:34 AM
    ///     Format: yyyy-MM-dd'T'HH:mm:ss
    ///     Result: 2017-01-05T08:34:00
    case yyyyMMddTHHmmss = "yyyy-MM-dd'T'HH:mm:ss"

    /// Full numeric date with timezone.
    ///
    ///     Date  : January 5, 2017, 12:34 AM
    ///     Format: yyyy-MM-dd'T'HH:mm:ss.SSSZ
    ///     Result: 2017-01-05T08:34:00.000+0000
    case yyyymmddTHHmmssSSZ = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

    /// Full date with timezone.
    ///
    ///     Date  : January 5, 2017, 12:34 AM
    ///     Format: d LLLL yyyy HH:mm:ss.SSSZ
    ///     Result: 5 January 2017 08:34:00.000+0000
    case dLLLLyyyyHHmmssSSSZ = "d LLLL yyyy HH:mm:ss.SSSZ"

    /// Full date with timezone.
    ///
    ///     Date  : July 7, 2017, 10:36 AM
    ///     Format: yyyy-MM-dd'T'HH:mm:ssZ
    ///     Result: 2017-07-20T10:36:34+0000
    case yyyyMMddTHHmmssZ = "yyyy-MM-dd'T'HH:mm:ssZ"

    static var all: [DateFormat] {
        return [
            .mm,
            .yy,
            .MM,
            .yyyy,
            .MMMM,
            .LLLd,
            .MMMdd,
            .MMyyyy,
            .MM_yyyy,
            .MMMdotdd,
            .MMddyyyy,
            .yyyyddMM,
            .yyyyMMdd,
            .MMddYYYY,
            .dLLLLyyyy,
            .MMMddyyyy,
            .MMMMddyyyy,
            .yyyyMMddTHHmmss,
            .yyyymmddTHHmmssSSZ,
            .dLLLLyyyyHHmmssSSSZ,
            .yyyyMMddTHHmmssZ
        ]
    }
}
