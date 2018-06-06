import UIKit

class SearchResultVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SearchPerformerDelegate {

    private let kCellIdentifier = "SearchResultCell"
    @IBOutlet private weak var collectionView: UICollectionView?

    private var searchPerformer: SearchPerformer {
        let searchPerformer = SearchPerformer()
        searchPerformer.delegate = self

        return searchPerformer
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .always

        collectionView?.register(UINib(nibName: "SearchResultCell", bundle: nil), forCellWithReuseIdentifier: kCellIdentifier)

        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 10)
        collectionView?.setCollectionViewLayout(layout, animated: false)
    }

    func startSearch(_ searchInfo: SearchInfo) {
        searchPerformer.startSearch(searchInfo)
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: kCellIdentifier, for: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 194)
    }

    // MARK: - SearchPerformerDelegate

    func didReceiveData() {
    }

    func didFail(with error: Error) {

    }

    func didFinishSearch() {

    }

}
