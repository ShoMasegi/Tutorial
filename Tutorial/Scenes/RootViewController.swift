import UIKit

class RootViewController: UIViewController, FadeTransitionable {

    var current: UIViewController?

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCurrent()
    }

    override var childForStatusBarStyle: UIViewController? {
        return current
    }
    override var childForStatusBarHidden: UIViewController? {
        return current
    }
}
