import UIKit

extension UIViewController {
    func hideBackButtonTitle() {
        let backBarButton = UIBarButtonItem()
        backBarButton.title = ""
        navigationItem.backBarButtonItem = backBarButton
    }
}
