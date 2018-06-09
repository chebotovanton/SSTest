class PriceFormatter {
    static func priceString(itinerary: Itinerary) -> String {
        if let minPrice = itinerary.pricingOptions?.min(by: { $0.price < $1.price })?.price {
            return String(format: "£%.0f", minPrice)
        }
        return "Unknown"
    }
}
