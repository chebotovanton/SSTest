import XCTest
@testable import SkyscannerTest

class SearchDatesCalculatorTests: XCTestCase {

    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")!

        return dateFormatter
    }

    func testSimpleWeekSwitch() {
        let date = dateFormatter.date(from: "2018-06-06")!
        let result = SearchDatesCalculator.nextMondayString(from: date)
        XCTAssertEqual(result, "2018-06-11", "SearchDatesCalculator fails next monday detection")
    }

    func testSimpleWeekSwitch2() {
        let date = dateFormatter.date(from: "2018-06-10")!
        let result = SearchDatesCalculator.nextMondayString(from: date)
        XCTAssertEqual(result, "2018-06-11", "SearchDatesCalculator fails next monday detection")
    }

    func testLastWeekOfMonth() {
        let date = dateFormatter.date(from: "2018-06-29")!
        let result = SearchDatesCalculator.nextMondayString(from: date)
        XCTAssertEqual(result, "2018-07-02", "SearchDatesCalculator fails next monday detection in next month")
    }

    func testMondayItself() {
        let date = dateFormatter.date(from: "2018-06-18")!
        let result = SearchDatesCalculator.nextMondayString(from: date)
        XCTAssertEqual(result, "2018-06-25", "SearchDatesCalculator fails detecting NEXT monday from some monday")
    }

    func testLastWeekOfYear() {
        let date = dateFormatter.date(from: "2018-12-31")!
        let result = SearchDatesCalculator.nextMondayString(from: date)
        XCTAssertEqual(result, "2019-01-07", "SearchDatesCalculator fails detecting next monday in next year")
    }

    func testNextTuesday() {
        let date = dateFormatter.date(from: "2018-06-06")!
        let result = SearchDatesCalculator.nextTuesdayString(from: date)
        XCTAssertEqual(result, "2018-06-12", "SearchDatesCalculator fails next tuesday detection")
    }

    func testNextTuesdayFromSomeMonday() {
        let date = dateFormatter.date(from: "2018-06-18")!
        let result = SearchDatesCalculator.nextTuesdayString(from: date)
        XCTAssertEqual(result, "2018-06-26", "SearchDatesCalculator fails detecting next tuesday from some monday")
    }

    func testLastWeekOfYear2() {
        let date = dateFormatter.date(from: "2018-12-31")!
        let result = SearchDatesCalculator.nextTuesdayString(from: date)
        XCTAssertEqual(result, "2019-01-08", "SearchDatesCalculator fails detecting next tuesday from last monday in a year")
    }

}
