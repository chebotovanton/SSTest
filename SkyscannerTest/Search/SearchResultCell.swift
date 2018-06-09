import UIKit
import SDWebImage

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

        setLogo(imageView: outboundLogo, leg: itinerary.outboundLeg)
        setLogo(imageView: returnLogo, leg: itinerary.inboundLeg)

        outboundTime?.text = timeString(leg: itinerary.outboundLeg)
        returnTime?.text = timeString(leg: itinerary.inboundLeg)
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
            return "£\(minPrice)"
        }
        return "Unknown"
    }

    private func descriptionString(leg: Leg?) -> String {
        var result = ""
        if let originCode = leg?.originStation?.code, let destinationCode = leg?.destinationStation?.code {
            result += originCode + "-" + destinationCode
        }
        if let carrierName =  leg?.segments.first?.carrier?.name {
            result += ", " + carrierName
        }

        return result.count > 0 ? result : "Unknown"
    }

    private func setLogo(imageView: UIImageView?, leg: Leg?) {
        if let code = leg?.segments.first?.carrier?.code {
            let urlString = String(format: "https://logos.skyscnr.com/images/airlines/favicon/%@.png", code)
            imageView?.sd_setImage(with: URL(string:  urlString), completed: nil)
        }
    }

    private func timeString(leg: Leg?) -> String {
        if let departure = leg?.departure, let arrival = leg?.arrival {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: departure) + " - " + formatter.string(from: arrival)
        }

        return "Unknown"
    }

}
