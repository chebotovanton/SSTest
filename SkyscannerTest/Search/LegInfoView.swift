import UIKit

class LegInfoView: UIView {

    private static let boldFont = UIFont.systemFont(ofSize: 16, weight: .bold)
    private static let regularFont = UIFont.systemFont(ofSize: 12)

    private static let boldTextColor = UIColor(red: 84.0/255.0, green: 76.0/255.0, blue: 99.0/255.0, alpha: 1)
    private static let regularTextColor = UIColor(red: 137.0/255.0, green: 130.0/255.0, blue: 148.0/255.0, alpha: 0.74)

    private let logoView = UIImageView()
    private let timeLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let transfersLabel = UILabel()
    private let durationLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialize() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews()
        addConstraints()
    }

    private func addSubviews() {
        addSubview(logoView)
        addSubview(timeLabel)
        addSubview(descriptionLabel)
        addSubview(transfersLabel)
        addSubview(durationLabel)

        timeLabel.font = LegInfoView.boldFont
        timeLabel.textColor = LegInfoView.boldTextColor

        transfersLabel.font = LegInfoView.boldFont
        transfersLabel.textColor = LegInfoView.boldTextColor

        descriptionLabel.font = LegInfoView.regularFont
        descriptionLabel.textColor = LegInfoView.regularTextColor

        durationLabel.font = LegInfoView.regularFont
        durationLabel.textColor = LegInfoView.regularTextColor
    }

    private func addConstraints() {
        logoView.autoPinEdge(toSuperviewEdge: .left)
        logoView.autoPinEdge(toSuperviewEdge: .top)
        logoView.autoSetDimensions(to: CGSize(width: 31, height: 31))

        timeLabel.autoPinEdge(toSuperviewEdge: .top, withInset: -2)
        timeLabel.autoPinEdge(.leading, to: .trailing, of: logoView, withOffset: 16)

        descriptionLabel.autoPinEdge(.leading, to: .leading, of: timeLabel, withOffset: 0)
        descriptionLabel.autoPinEdge(.top, to: .bottom, of: timeLabel, withOffset: 3)

        transfersLabel.autoPinEdge(toSuperviewEdge: .top, withInset: -2)
        transfersLabel.autoPinEdge(toSuperviewEdge: .trailing)

        durationLabel.autoPinEdge(toSuperviewEdge: .trailing)
        durationLabel.autoPinEdge(.top, to: .bottom, of: transfersLabel, withOffset: 3)
    }

    func setup(leg: Leg?) {
        durationLabel.text = durationString(leg: leg)
        transfersLabel.text = typeString(leg: leg)
        descriptionLabel.text = descriptionString(leg: leg)
        setLogo(imageView: logoView, leg: leg)
        timeLabel.text = timeString(leg: leg)
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
            imageView?.sd_setImage(with: URL(string: urlString), completed: nil)
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
