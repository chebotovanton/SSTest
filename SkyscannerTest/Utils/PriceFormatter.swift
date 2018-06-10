class PriceFormatter {
    static func priceString(itinerary: Itinerary) -> String {
        if let minPrice = itinerary.calculateMinPrice() {
            return String(format: "£%f", minPrice)
//            return String(format: "£%.0f", minPrice)
        }
        return "Unknown"
    }
}
