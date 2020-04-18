import Foundation

enum DateFormat: String {
    case rfc822 = "E, d MMM yyyy HH:mm:ss Z"
    case yMMdd = "y-MM-dd"
}

extension DateFormatter {
    static func with(format: DateFormat) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter
    }
}
