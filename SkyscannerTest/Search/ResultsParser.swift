import Foundation
import UIKit
import AlamofireObjectMapper
import ObjectMapper

struct PollResponse: Mappable {
    var sessionKey: String?
    var status: String?
    var itineraries: [Itinerary]?
    var legs: [Leg]?
    var places: [Place]?

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        sessionKey <- map["SessionKey"]
        status <- map["Status"]
        itineraries <- map["Itineraries"]
        legs <- map["Legs"]
        places <- map["Places"]
    }
}

class Itinerary: Mappable {
    var outboundLeg: Leg?
    var inboundLeg: Leg?
    var outboundLegId: String?
    var inboundLegId: String?
    var pricingOptions: [PricingOption]?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        outboundLegId <- map["OutboundLegId"]
        inboundLegId <- map["InboundLegId"]
        pricingOptions <- map["PricingOptions"]
    }
}

class Leg: Mappable {
    var legId: String?
    var duration: Int?
    var departure: String?
    var arrival: String?
    var originStationId: Int?
    var destinationStationId: Int?
    var segmentIds: [Int]?

    var originStation: Place?
    var destinationStation: Place?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        legId <- map["Id"]
        segmentIds <- map["SegmentIds"]
        duration <- map["Duration"]
        departure <- map["Departure"]
        arrival <- map["Arrival"]
        originStationId <- map["OriginStation"]
        destinationStationId <- map["DestinationStation"]
    }
}

struct PricingOption: Mappable {
    var price: Double?
    var deeplinkUrl: String?

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        price <- map["Price"]
        deeplinkUrl <- map["DeeplinkUrl"]
    }
}

struct Place: Mappable {
    var placeId: Int?
    var code: String?

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        placeId <- map["Id"]
        code <- map["Code"]
    }
}

class ResultsParser {
    static func parseResults(_ pollResponse: PollResponse) -> (results: Array<Itinerary>, shouldContinueSearch: Bool) {
        //fill itineraries with all other data
        //tests?
        // complexity? O(n)?

        pollResponse.legs?.forEach({ (leg) in
            leg.originStation = pollResponse.places?.first(where: { $0.placeId == leg.originStationId })
            leg.destinationStation = pollResponse.places?.first(where: { $0.placeId == leg.destinationStationId })
        })

        pollResponse.itineraries?.forEach({ (itinerary) in
            itinerary.inboundLeg = pollResponse.legs?.first(where: { $0.legId == itinerary.inboundLegId })
            itinerary.outboundLeg = pollResponse.legs?.first(where: { $0.legId == itinerary.outboundLegId })
        })

        let shouldContinueSearch = (pollResponse.status != "UpdatesComplete")
        
        return(pollResponse.itineraries ?? [], shouldContinueSearch)
    }
}
