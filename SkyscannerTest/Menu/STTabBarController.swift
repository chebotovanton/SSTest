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
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -3)
        tabBar.layer.shadowRadius = 8
        tabBar.layer.shadowColor = UIColor(red: 84.0/255.0, green: 76.0/255.0, blue: 99.0/255.0, alpha: 0.36).cgColor
        tabBar.layer.shadowOpacity = 1
        tabBar.layer.masksToBounds = false
    }
}
