import UIKit

class SearchResultVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SearchPerformerDelegate {

    private let kCellIdentifier = "SearchResultCell"
    @IBOutlet private weak var collectionView: UICollectionView?
    @IBOutlet private weak var statusLabel: UILabel?
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView?
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
    }

    func startSearch(_ searchInfo: SearchInfo) {
        let searchPerformer = SearchPerformer()
        searchPerformer.delegate = self
        searchPerformer.startSearch(searchInfo)
        self.searchPerformer = searchPerformer
    }

    private func switchStatusText(newText: String) {
        let duration = 0.5
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: .beginFromCurrentState,
                       animations: { [weak self] in
                        self?.statusLabel?.alpha = 0
        }) { [weak self] (finished) in
            self?.statusLabel?.text = newText
            UIView.animate(withDuration: duration,
                           animations: { [weak self] in self?.statusLabel?.alpha = 1 },
                           completion: nil)
        }
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

    func didReceiveData(_ newItiniraries: [Itinerary]) {
//        itineraries = itineraries + newItiniraries
        itineraries = newItiniraries
        if itineraries.count > 0 {
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                self?.collectionView?.alpha = 1
                self?.activityIndicator?.alpha = 0
                self?.statusLabel?.alpha = 0
            }) { [weak self] (finished) in
                self?.activityIndicator?.stopAnimating()
            }
        }
        collectionView?.reloadData()
    }

    func didFail(with error: Error?) {
        switchStatusText(newText: "Oops, something went wrong")
    }

    func didFinishSearch(finished: Bool) {
        
    }
}
