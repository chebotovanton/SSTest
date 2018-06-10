import Foundation
import UIKit
import AlamofireObjectMapper
import ObjectMapper

struct PollResponse: ImmutableMappable {
    var sessionKey: String
    var status: String
    var itineraries: [Itinerary]
    var legs: [Leg]
    var places: [Place]
    var segments: [Segment]
    var carriers: [Carrier]

    init(map: Map) throws {
        sessionKey = try map.value("SessionKey")
        status = try map.value("Status")
        itineraries = try map.value("Itineraries")
        legs = try map.value("Legs")
        places = try map.value("Places")
        segments = try map.value("Segments")
        carriers = try map.value("Carriers")
    }

    mutating func mapping(map: Map) {
    }
}

class Itinerary: Mappable {
    var outboundLeg: Leg?
    var inboundLeg: Leg?
    var outboundLegId: String?
    var inboundLegId: String?
    var pricingOptions: [PricingOption]?
    var features: [String] = []

    required init?(map: Map) {
    }

    init() {
    }

    func mapping(map: Map) {
        outboundLegId <- map["OutboundLegId"]
        inboundLegId <- map["InboundLegId"]
        pricingOptions <- map["PricingOptions"]
    }

    func calculateMinPrice() -> Double? {
        return pricingOptions?.min(by: { $0.price < $1.price })?.price
    }

    func totalDuration() -> Int? {
        if let outDuration = outboundLeg?.duration, let inDuration = inboundLeg?.duration {
            return outDuration + inDuration
        }

        return nil
    }
}

class Leg: Mappable {
    static var dateTransform: DateFormatterTransform {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss"
        let dateTransform = DateFormatterTransform(dateFormatter: dateFormatter)

        return dateTransform
    }

    var legId: String?
    var duration: Int?
    var departure: Date?
    var arrival: Date?
    var originStationId: Int?
    var destinationStationId: Int?
    var segmentIds: [Int]?

    var originStation: Place?
    var destinationStation: Place?
    var segments: [Segment] = []

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        legId <- map["Id"]
        segmentIds <- map["SegmentIds"]
        duration <- map["Duration"]
        departure <- (map["Departure"], Leg.dateTransform)
        arrival <- (map["Arrival"], Leg.dateTransform)
        originStationId <- map["OriginStation"]
        destinationStationId <- map["DestinationStation"]
    }
}

struct PricingOption: ImmutableMappable {
    var price: Double
    var deeplinkUrl: String

    init(map: Map) throws {
        price = try map.value("Price")
        deeplinkUrl = try map.value("DeeplinkUrl")
    }

    init(price: Double, deeplinkUrl: String) {
        self.price = price
        self.deeplinkUrl = deeplinkUrl
    }

    mutating func mapping(map: Map) {
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

class Segment: Mappable {
    var segmentId: Int?
    var carrierId: Int?

    var carrier: Carrier?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        segmentId <- map["Id"]
        carrierId <- map["Carrier"]
    }
}

struct Carrier: Mappable {
    var carrierId: Int?
    var name: String?
    var code: String?

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        carrierId <- map["Id"]
        name <- map["Name"]
        code <- map["Code"]
    }
}

class ResultsParser {
    static func parseResults(_ pollResponse: PollResponse) -> (results: [Itinerary], shouldContinueSearch: Bool) {
        //tests?
        // complexity? O(n)?

        pollResponse.segments.forEach({ (segment) in
            segment.carrier = pollResponse.carriers.first { $0.carrierId == segment.carrierId }
        })

        pollResponse.legs.forEach({ (leg) in
            leg.originStation = pollResponse.places.first { $0.placeId == leg.originStationId }
            leg.destinationStation = pollResponse.places.first { $0.placeId == leg.destinationStationId }

            leg.segmentIds?.forEach({ (segmentId) in
                if let segment = pollResponse.segments.first(where: { $0.segmentId! == segmentId }) {
                    leg.segments.append(segment)
                }
            })
        })

        pollResponse.itineraries.forEach({ (itinerary) in
            itinerary.inboundLeg = pollResponse.legs.first { $0.legId == itinerary.inboundLegId }
            itinerary.outboundLeg = pollResponse.legs.first { $0.legId == itinerary.outboundLegId }
        })

        let shouldContinueSearch = (pollResponse.status != "UpdatesComplete")

        return(pollResponse.itineraries, shouldContinueSearch)
    }
}
