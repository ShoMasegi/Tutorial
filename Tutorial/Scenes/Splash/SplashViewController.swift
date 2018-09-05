import UIKit
import SnapKit

class SplashViewController: UIViewController {
    private let viewModel: SplashViewModel

    init() {
        viewModel = SplashViewModel(useCase: Application.shared.defaultUseCaseProvider().makeSplashUseCase())
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews()
        activityIndicator.startAnimating()
        prepare()
    }

    private lazy var logoView: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Menlo", size: 30)
        label.text = "Tutorial"
        label.textAlignment = .center
        return label
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.backgroundColor = .clear
        return indicator
    }()

    private func setupSubviews() {
        [logoView, activityIndicator].forEach(view.addSubview)
        logoView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        activityIndicator.snp.makeConstraints {
            $0.top.equalTo(logoView.snp.bottom).offset(60)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(44)
        }
    }

    private func prepare() {
        viewModel.getEvens(onSuccess: { _ in
            let nc = UINavigationController(rootViewController: EventsViewController())
            Application.shared.rootViewController.animateFadeTransition(to: nc)
        }, onError: { message in
            self.presentAlert(message: message)
        })
    }

    private func presentAlert(title: String? = nil, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: {})
    }

    func appDidBecomeActive() {
        prepare()
    }
}
