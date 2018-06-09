import UIKit
import SDWebImage
import PureLayout

class SearchResultCell: UICollectionViewCell {

    private let outboundLegInfoView = LegInfoView()
    private let inboundLegInfoView = LegInfoView()

    @IBOutlet private weak var ratingImageView: UIImageView?
    @IBOutlet private weak var ratingLabel: UILabel?
    @IBOutlet private weak var featuresDescription: UILabel?
    @IBOutlet private weak var mutipleBookingsDescription: UILabel?

    @IBOutlet private weak var priceLabel: UILabel?

    override func awakeFromNib() {
        addSubviews()
        addConstraints()
    }

    private func addSubviews() {
        addSubview(outboundLegInfoView)
        addSubview(inboundLegInfoView)
    }

    private func addConstraints() {
        outboundLegInfoView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        outboundLegInfoView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        outboundLegInfoView.autoPinEdge(toSuperviewEdge: .top, withInset: 24)
        outboundLegInfoView.autoSetDimension(.height, toSize: 33)

        inboundLegInfoView.autoPinEdge(.top, to: .bottom, of: outboundLegInfoView, withOffset: 25)
        inboundLegInfoView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        inboundLegInfoView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        inboundLegInfoView.autoSetDimension(.height, toSize: 33)
    }

    func setup(_ itinerary: Itinerary) {
        priceLabel?.text = priceString(itinerary: itinerary)
        outboundLegInfoView.setup(leg: itinerary.outboundLeg)
        inboundLegInfoView.setup(leg: itinerary.inboundLeg)
    }

    private func priceString(itinerary: Itinerary) -> String {
        //return lowest price
        if let minPrice = itinerary.pricingOptions?.first?.price {
            return "£\(minPrice)"
        }
        return "Unknown"
    }
}
