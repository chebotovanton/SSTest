class ParametersConverter {
    static func searchSessionInitParameters(searchInfo: SearchInfo, apiKey: String) -> [String: String] {
        return ["cabinclass" : "Economy",
                "country" : "UK",
                "currency" : "GBP",
                "locale" : "en-GB",
                "locationSchema" : searchInfo.locationSchema,
                "originplace" : searchInfo.originIata,
                "destinationplace" : searchInfo.destinationIata,
                "outbounddate" : searchInfo.outboundDate,
                "inbounddate" : searchInfo.inboundDate,
                "adults" : "1",
                "children" : "0",
                "infants" : "0",
                "apiKey" : apiKey]
    }

    static func pollParameters(apiKey: String, pageIndex: Int, pageSize: Int) -> [String: Any] {
        return ["apiKey" : apiKey,
                "pageIndex" : 0,
                "pageSize" : pageSize]
    }
}
