import UIKit

class SearchResultVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SearchPerformerDelegate {

    private let kCellIdentifier = "SearchResultCell"
    @IBOutlet private weak var collectionView: UICollectionView?
    @IBOutlet private weak var statusLabel: UILabel?
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView?
    @IBOutlet private weak var navBarView: UIView?
    @IBOutlet private weak var resultsCountLabel: UILabel?
    @IBOutlet private weak var datesLabel: UILabel?
    private var itineraries: [Itinerary] = []

    private var searchPerformer: SearchPerformer?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .always

        collectionView?.register(UINib(nibName: "SearchResultCell", bundle: nil), forCellWithReuseIdentifier: kCellIdentifier)

        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        collectionView?.setCollectionViewLayout(layout, animated: false)
        collectionView?.alwaysBounceVertical = true

        collectionView?.alpha = 0
        statusLabel?.text = "Initializing search session"

        navBarView?.layer.shadowOffset = CGSize(width: 0, height: 3)
        navBarView?.layer.shadowRadius = 8
        navBarView?.layer.shadowColor = UIColor(red: 84.0/255.0, green: 76.0/255.0, blue: 99.0/255.0, alpha: 0.36).cgColor
        navBarView?.layer.shadowOpacity = 1
        navBarView?.layer.masksToBounds = false

        if let searchInfo = searchPerformer?.searchInfo {
            datesLabel?.text = DatesStringFormatter.datesDescription(searchInfo: searchInfo)
        }
    }

    deinit {
        self.searchPerformer?.stopLoading()
    }

    func startSearch(_ searchInfo: SearchInfo) {
        let searchPerformer = SearchPerformer()
        searchPerformer.delegate = self
        searchPerformer.startSearch(searchInfo)
        self.searchPerformer = searchPerformer

        datesLabel?.text = DatesStringFormatter.datesDescription(searchInfo: searchInfo)
    }

    private func switchStatusText(newText: String) {
        let duration = 0.5
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: .beginFromCurrentState,
                       animations: { [weak self] in
                        self?.statusLabel?.alpha = 0
        }, completion: { [weak self] (_) in
                self?.statusLabel?.text = newText
                UIView.animate(withDuration: duration,
                               animations: { [weak self] in self?.statusLabel?.alpha = 1 },
                               completion: nil)
        })
    }

    private func updateResultsCountLabel() {
        let count = itineraries.count
        resultsCountLabel?.text = "\(count) of \(count) results shown"
    }

    @IBAction private func goBack() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itineraries.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellIdentifier, for: indexPath)
        if let resultCell = cell as? SearchResultCell {
            resultCell.setup(itineraries[indexPath.row])
        }

        if indexPath.row == itineraries.count - 1 {
            searchPerformer?.pollNextPage()
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
        let sectionInset = (flowLayout?.sectionInset.right ?? 0) + (flowLayout?.sectionInset.left ?? 0)
        let contentInset = collectionView.contentInset.left + collectionView.contentInset.right
        let width = collectionView.frame.width - sectionInset - contentInset

        return CGSize(width: width, height: 194)
    }

    // MARK: - SearchPerformerDelegate

    func didStartSearch() {
        switchStatusText(newText: "Fetching results")
    }

    func didReceiveFirstPage(_ itiniraries: [Itinerary]) {
        itineraries = itiniraries
        if itineraries.count > 0 {
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                self?.collectionView?.alpha = 1
                self?.activityIndicator?.alpha = 0
                self?.statusLabel?.alpha = 0
            }, completion: { [weak self] (_) in
                self?.activityIndicator?.stopAnimating()
            })
        }
        collectionView?.reloadData()
        updateResultsCountLabel()
    }

    func didReceiveNextPage(_ newItiniraries: [Itinerary]) {
        itineraries += newItiniraries
        collectionView?.reloadData()
        updateResultsCountLabel()
    }

    func didFail(with error: Error?) {
        switchStatusText(newText: "Oops, something went wrong")
    }
}
