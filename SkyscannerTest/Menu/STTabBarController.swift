import UIKit

class STTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBar.appearance().tintColor = UIColor(red: 0, green: 178.0/255.0, blue: 214.0/255.0, alpha: 1.0)
        if let items = tabBar.items {
            for item in items {
                item.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
            }
        }
    }
}
