import Foundation

class SearchDatesCalculator {

    private static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        return dateFormatter
    }

    private static var calendar: Calendar {
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(abbreviation: "GMT")!

        return calendar
    }

    static func nextMondayString(from date: Date) -> String {
        let weekday = (calendar.firstWeekday == 1) ? 2 : 1
        let nextMonday = calendar.nextDate(after: date, matching: DateComponents(weekday: weekday), matchingPolicy: .nextTime)!

        return dateFormatter.string(from: nextMonday)
    }

    static func nextTuesdayString(from date: Date) -> String {
        let weekday = (calendar.firstWeekday == 1) ? 3 : 2
        let nextTuesday = calendar.nextDate(after: date, matching: DateComponents(weekday: weekday), matchingPolicy: .strict)!

        return dateFormatter.string(from: nextTuesday)
    }
}
