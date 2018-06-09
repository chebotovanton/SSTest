import UIKit

class SearchResultCell: UICollectionViewCell {

    @IBOutlet private weak var outboundLogo: UIImageView?
    @IBOutlet private weak var returnLogo: UIImageView?
    @IBOutlet private weak var outboundTime: UILabel?
    @IBOutlet private weak var returnTime: UILabel?
    @IBOutlet private weak var outboundDescription: UILabel?
    @IBOutlet private weak var returnDescription: UILabel?

    @IBOutlet private weak var outboundType: UILabel?
    @IBOutlet private weak var returnType: UILabel?
    @IBOutlet private weak var outboundDuration: UILabel?
    @IBOutlet private weak var returnDuration: UILabel?

    @IBOutlet private weak var ratingImageView: UIImageView?
    @IBOutlet private weak var ratingLabel: UILabel?
    @IBOutlet private weak var featuresDescription: UILabel?
    @IBOutlet private weak var mutipleBookingsDescription: UILabel?

    @IBOutlet private weak var priceLabel: UILabel?

    func setup(_ itinerary: Itinerary) {
        priceLabel?.text = priceString(itinerary: itinerary)
        outboundDuration?.text = durationString(leg: itinerary.outboundLeg)
        returnDuration?.text = durationString(leg: itinerary.inboundLeg)

        outboundType?.text = typeString(leg: itinerary.outboundLeg)
        returnType?.text = typeString(leg: itinerary.inboundLeg)

        outboundDescription?.text = descriptionString(leg: itinerary.outboundLeg)
        returnDescription?.text = descriptionString(leg: itinerary.inboundLeg)
    }

    private func durationString(leg: Leg?) -> String {
        if let duration = leg?.duration {
            let hours = Int(duration / 60)
            let minutes = duration % 60
            return "\(hours)" + "h " + "\(minutes)" + "m"
        }
        return "Unknown"
    }

    private func typeString(leg: Leg?) -> String {
        if let segmentIds = leg?.segmentIds {
            if segmentIds.count > 1 {
                return "\(segmentIds.count) stops"
            } else {
                return "Direct"
            }
        }
        return "Unknown"
    }

    private func priceString(itinerary: Itinerary) -> String {
        //return lowest price
        if let minPrice = itinerary.pricingOptions?.first?.price {
            return "\(minPrice)"
        }
        return "Unknown"
    }

    private func descriptionString(leg: Leg?) -> String {
        if let originCode = leg?.originStation?.code, let destinationCode = leg?.destinationStation?.code {
            return originCode + "–" + destinationCode + ", unknown carrier"
        }

        return "Unknown"
    }

}
