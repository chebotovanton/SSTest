import UIKit

class SearchResultVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private let kCellIdentifier = "SearchResultCell"
    @IBOutlet private weak var collectionView: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.register(UINib(nibName: "SearchResultCell", bundle: nil), forCellWithReuseIdentifier: kCellIdentifier)

        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        collectionView?.setCollectionViewLayout(layout, animated: false)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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


}
