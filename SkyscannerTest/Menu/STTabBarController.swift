import UIKit

class STTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let items = tabBar.items {
            for item in items {
                item.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
            }
        }
    }
}
