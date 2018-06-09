import XCTest
@testable import SkyscannerTest

class PriceFormatterTests: XCTestCase {
    func testNoPricingOptions() {
        let itinerary = Itinerary()
        itinerary.pricingOptions = []

        XCTAssertEqual(PriceFormatter.priceString(itinerary: itinerary), "Unknown")
    }

    func testMinPriceCalculation() {
        let itinerary = Itinerary()
        itinerary.pricingOptions = [PricingOption(price: 50.5, deeplinkUrl: "test url"),
                                    PricingOption(price: 10.123, deeplinkUrl: "test url"),
                                    PricingOption(price: 60.6, deeplinkUrl: "test url"),
                                    PricingOption(price: 40.4, deeplinkUrl: "test url")]

        XCTAssertEqual(PriceFormatter.priceString(itinerary: itinerary), "£10")
    }
}
