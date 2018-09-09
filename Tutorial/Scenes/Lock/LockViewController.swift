import UIKit
import SnapKit

class LockViewController: UIViewController {
    enum LockType {
        case badRequest
        case forbidden
        case unprocessableEntity
        case notFound

        var title: String {
            switch self {
            case .badRequest: return "Bad Request"
            case .forbidden: return "Forbidden"
            case .unprocessableEntity: return "Unprocessable Entity"
            case .notFound: return "Not Found"
            }
        }

        var url: String {
            return "https://github.com/ShoMasegi/Tutorial"
        }
    }

    private let type: LockType

    init(type: LockType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var alert: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.layer.shadowColor = UIColor(white: 0, alpha: 0.5).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        view.layer.shadowRadius = 10
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        view.layer.shadowOpacity = 1
        view.layer.masksToBounds = false
        return view
    }()

    private lazy var imageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "info"))
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()

    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button.setTitle("問題を報告", for: .normal)
        return button
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()

    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var line: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        setupSubviews()
        titleLabel.text = type.title
        bodyLabel.text = "データを取得できませんでした。一度アプリを閉じてください。\n 問題があればGithubにissueを立ててください。"
    }

    private func setupSubviews() {
        view.addSubview(alert)
        [imageView, button, titleLabel, bodyLabel, line].forEach(alert.addSubview)

        alert.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(280)
        }
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(56)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(10)
        }
        bodyLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(10)
        }
        button.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(bodyLabel.snp.bottom).offset(14)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(50)
            $0.left.right.equalToSuperview()
        }
        line.snp.makeConstraints {
            $0.bottom.equalTo(button.snp.top)
            $0.left.right.equalTo(button)
            $0.height.equalTo(1.0 / UIScreen.main.scale)
        }
    }

    @objc private func buttonTapped(_: UIButton) {
        guard let url = URL(string: type.url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    func appDidBecomeActive() {
        Application.shared.rootViewController.animateFadeTransition(to: SplashViewController())
    }
}
