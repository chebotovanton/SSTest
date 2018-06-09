class DatesStringFormatter {
    static func datesDescription(searchInfo: SearchInfo) -> String {
        return searchInfo.outboundDate + " – " + searchInfo.inboundDate
    }
}
