 import UIKit
import SnapKit

class RepositoryInfoCell: UIView {

    enum CellType {
        case star(count: Int)
        case watch(count: Int)
        case fork(count: Int)

        var image: UIImage? {
            switch self {
            case .star: return UIImage(named: "star")
            case .watch: return UIImage(named: "watch")
            case .fork: return UIImage(named: "fork")
            default: return nil
            }
        }

        var title: String {
            switch self {
            case .star: return "Stargazers"
            case .watch: return "Watchers"
            case .fork: return "Forks"
            }
        }

        var count: Int {
            switch self {
            case .star(let count): return count
            case .watch(let count): return count
            case .fork(let count): return count
            }
        }
    }

    var type: CellType = .star(count: 0) {
        didSet {
            iconImageView.image = type.image
            titleLabel.text = type.title
            contentLabel.text = type.count.withComma
        }
    }

    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.t_border.cgColor
        setupSubviews()
    }

    required init?(coder _: NSCoder) { fatalError() }

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = self.type.image
        return imageView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.text = self.type.title
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.text = self.type.count.withComma
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        return stackView
    }()

    private func setupSubviews() {
        [iconImageView, contentLabel].forEach(stackView.addArrangedSubview)
        [stackView, titleLabel].forEach(self.addSubview)
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(7)
            $0.left.greaterThanOrEqualToSuperview().offset(10)
            $0.right.lessThanOrEqualToSuperview().offset(-10)
            $0.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(2)
            $0.left.greaterThanOrEqualToSuperview().offset(10)
            $0.right.lessThanOrEqualToSuperview().offset(-10)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(7)
        }
        iconImageView.snp.makeConstraints {
            $0.height.width.equalTo(16)
        }
    }
}

extension Int {

    var withComma: String? {
        let num = NSNumber(integerLiteral: self)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        return formatter.string(from: num)
    }
}
