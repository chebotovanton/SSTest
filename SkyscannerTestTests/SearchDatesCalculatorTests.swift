import XCTest
@testable import SkyscannerTest

class SearchDatesCalculatorTests: XCTestCase {

    func testSimpleWeekSwitch() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: "2018-06-06")!
        let result = SearchDatesCalculator.nextMondayString(from: date)
        XCTAssertEqual(result, "2018-06-11", "Wrong dates calculation")
    }

    func testLastWeekOfMonth() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: "2018-06-29")!
        let result = SearchDatesCalculator.nextMondayString(from: date)
        XCTAssertEqual(result, "2018-07-02", "Wrong dates calculation")
    }

    func testMondayItself() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: "2018-06-18")!
        let result = SearchDatesCalculator.nextMondayString(from: date)
        XCTAssertEqual(result, "2018-06-25", "Wrong dates calculation")
    }

    func testLastWeekOfYear() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: "2018-12-31")!
        let result = SearchDatesCalculator.nextMondayString(from: date)
        XCTAssertEqual(result, "2019-01-07", "Wrong dates calculation")
    }
        
}
