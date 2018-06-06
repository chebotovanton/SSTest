import UIKit

class SearchResultCell: UICollectionViewCell {

    @IBOutlet private weak var departureLogo: UIImageView?
    @IBOutlet private weak var returnLogo: UIImageView?
    @IBOutlet private weak var departureTime: UILabel?
    @IBOutlet private weak var returnTime: UILabel?
    @IBOutlet private weak var departureDescription: UILabel?
    @IBOutlet private weak var returnDescription: UILabel?

    @IBOutlet private weak var departureType: UILabel?
    @IBOutlet private weak var returnType: UILabel?
    @IBOutlet private weak var departureDuration: UILabel?
    @IBOutlet private weak var returnDuration: UILabel?

    @IBOutlet private weak var ratingImageView: UIImageView?
    @IBOutlet private weak var ratingLabel: UILabel?
    @IBOutlet private weak var featuresDescription: UILabel?
    @IBOutlet private weak var mutipleBookingsDescription: UILabel?

    @IBOutlet private weak var priceLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
