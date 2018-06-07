import Foundation
import UIKit

class Itinerary {
    let price: Float

    init(price: Float) {
        self.price = price
    }
}

class Leg {

}

class Segment {

}

class ResultsParser {
    //move to another thread
    static func parseResults(_ raw: Dictionary<String, Any>) -> (results: Array<Itinerary>, shouldContinueSearch: Bool) {
        var itineraries: [Itinerary] = []
        if let rawItineraries = raw["Itineraries"] as? Array<Dictionary<String, Any>> {
            for rawIt in rawItineraries {
                let price = (rawIt["PricingOptions"] as? Array<Dictionary<String, Any>>)?.first?["Price"] as? CGFloat ?? 0
                itineraries.append(Itinerary(price: Float(price)))
            }
        }
        if let legs = raw["Legs"] as? Array<Any> {

        }
        if let segments = raw["Segments"] as? Array<Any> {

        }
        if let status = raw["Status"] as? String, status == "UpdatesComplete" {
            return (itineraries, false)
        } else {
            return (itineraries, true)
        }
    }
}
