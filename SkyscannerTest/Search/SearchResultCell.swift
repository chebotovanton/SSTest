import UIKit
import SDWebImage
import PureLayout

class SearchResultCell: UICollectionViewCell {

    private let outboundLegInfoView = LegInfoView()
    private let inboundLegInfoView = LegInfoView()

    @IBOutlet private weak var ratingImageView: UIImageView?
    @IBOutlet private weak var ratingLabel: UILabel?
    @IBOutlet private weak var featuresDescription: UILabel?
    @IBOutlet private weak var carriersLabel: UILabel?

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
        priceLabel?.text = PriceFormatter.priceString(itinerary: itinerary)
        carriersLabel?.text = carriersString(itinerary)
        setupFeaturesLabel(itinerary.features)

        outboundLegInfoView.setup(leg: itinerary.outboundLeg)
        inboundLegInfoView.setup(leg: itinerary.inboundLeg)
    }

    private func carriersString(_ itinerary: Itinerary) -> String {
        let inboundCarriersNames = itinerary.inboundLeg?.segments.compactMap { $0.carrier?.name } ?? []
        let outboundCarriersNames = itinerary.outboundLeg?.segments.compactMap { $0.carrier?.name } ?? []
        let allNames = Set(inboundCarriersNames + outboundCarriersNames)
        if allNames.count == 1 {
            return "via " + allNames.first!
        } else {
            return "\(allNames.count) bookings required"
        }
    }

    private func setupFeaturesLabel(_ features: [String]?) {
        featuresDescription?.isHidden = (features?.count == 0)
        featuresDescription?.text = features?.joined(separator: " ")
    }
}
