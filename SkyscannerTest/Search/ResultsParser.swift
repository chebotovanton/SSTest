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
    var segments: [Segment]?
    var carriers: [Carrier]?

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        sessionKey <- map["SessionKey"]
        status <- map["Status"]
        itineraries <- map["Itineraries"]
        legs <- map["Legs"]
        places <- map["Places"]
        segments <- map["Segments"]
        carriers <- map["Carriers"]
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
    static func parseResults(_ pollResponse: PollResponse) -> (results: Array<Itinerary>, shouldContinueSearch: Bool) {
        //fill itineraries with all other data
        //tests?
        // complexity? O(n)?

        pollResponse.segments?.forEach({ (segment) in
            segment.carrier = pollResponse.carriers?.first { $0.carrierId == segment.carrierId }
        })

        pollResponse.legs?.forEach({ (leg) in
            leg.originStation = pollResponse.places?.first { $0.placeId == leg.originStationId }
            leg.destinationStation = pollResponse.places?.first { $0.placeId == leg.destinationStationId }

            leg.segmentIds?.forEach({ (segmentId) in
                if let segment = pollResponse.segments?.first(where: { $0.segmentId! == segmentId }) {
                    leg.segments.append(segment)
                }
            })
        })

        pollResponse.itineraries?.forEach({ (itinerary) in
            itinerary.inboundLeg = pollResponse.legs?.first { $0.legId == itinerary.inboundLegId }
            itinerary.outboundLeg = pollResponse.legs?.first { $0.legId == itinerary.outboundLegId }
        })

        let shouldContinueSearch = (pollResponse.status != "UpdatesComplete")
        
        return(pollResponse.itineraries ?? [], shouldContinueSearch)
    }
}
