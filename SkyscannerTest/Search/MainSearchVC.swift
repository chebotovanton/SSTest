import UIKit

struct SearchInfo {
    var originIata = "EDI-sky"
    var destinationIata = "LOND-sky"
    var outboundDate = SearchDatesCalculator.nextMondayString(from: Date())
    var inboundDate =  SearchDatesCalculator.nextTuesdayString(from: Date())
    var locationSchema = "sky"
}

class MainSearchVC: UIViewController {

    @IBOutlet private weak var datesLabel: UILabel?

    private let searchInfo = SearchInfo()

    override func viewDidLoad() {
        super.viewDidLoad()

        datesLabel?.text = searchInfo.outboundDate + " – " + searchInfo.inboundDate
        navigationController?.isNavigationBarHidden = true
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let searchResultVC = segue.destination as? SearchResultVC {
            searchResultVC.startSearch(searchInfo)
        }
    }

}
