class FeaturesCalculator {
    static func distributeFeatures(itineraries: [Itinerary]) {
        var bestPriceIt: Itinerary?
        var minPrice = Double.greatestFiniteMagnitude
        var fastestItieraries: [Itinerary] = []
        var minDuration = Int.max
        for itinerary in itineraries {
            itinerary.features = []

            if let price = itinerary.calculateMinPrice(), price < minPrice {
                minPrice = price
                bestPriceIt = itinerary
            }
            if let duration = itinerary.totalDuration() {
                if duration < minDuration {
                    fastestItieraries = [itinerary]
                    minDuration = duration
                } else if duration == minDuration {
                    fastestItieraries.append(itinerary)
                }
            }
        }

        bestPriceIt?.features.append("Cheapest")
        fastestItieraries.forEach { $0.features.append("Shortest") }
    }
}
