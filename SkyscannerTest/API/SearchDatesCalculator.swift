import Foundation

class SearchDatesCalculator {

    private static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = timeZone()

        return dateFormatter
    }

    private static var calendar: Calendar {
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = timeZone()

        return calendar
    }

    private static func timeZone() -> TimeZone {
        return TimeZone(abbreviation: "GMT")!
    }

    static func nextMondayString(from date: Date) -> String {
        let nextMonday = getNextMonday(from: date)

        return dateFormatter.string(from: nextMonday)
    }

    static func nextTuesdayString(from date: Date) -> String {
        let nextMonday = getNextMonday(from: date)
        let nextTuesday = calendar.date(byAdding: .day, value: 1, to: nextMonday)!

        return dateFormatter.string(from: nextTuesday)
    }

    private static func getNextMonday(from date: Date) -> Date {
        let targetWeekday = (calendar.firstWeekday == 1) ? 2 : 1
        let dateWeekday = calendar.component(.weekday, from: date)
        var daysToAdd = targetWeekday + 7 - dateWeekday
        if daysToAdd > 7 {
            daysToAdd = daysToAdd % 7
        }

        return calendar.date(byAdding: .day, value: daysToAdd, to: date)!
    }
}
