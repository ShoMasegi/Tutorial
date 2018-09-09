import UIKit
import SnapKit

class ImageLabelCell: UIView {

    enum CellType {
        case access(isPrivate: Bool?)
        case lang(language: String?)
        case issue(count: Int?)
        case date(date: Date?)

        var image: UIImage? {
            switch self {
            case .access: return UIImage(named: "lock")
            case .lang: return UIImage(named: "language")
            case .issue: return UIImage(named: "issue")
            case .date: return UIImage(named: "date")
            }
        }

        var title: String {
            switch self {
            case .access(let isPrivate):
                return (isPrivate ?? false) ? "Private" : "Public"
            case .lang(let language):
                return language ?? "Unknown"
            case .issue(let count):
                return "\(count ?? 0) issues"
            case .date(let date):
                guard let date = date else { return "Unknown" }
                let formatter = DateFormatter()
                formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy/MM/dd", options: 0, locale: Locale(identifier: "ja_JP"))
                return formatter.string(from: date)
            }
        }
    }

    var type: CellType = .access(isPrivate: false) {
        didSet {
            self.titleLabel.text = type.title
            self.iconImageView.image = type.image
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
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.text = self.type.title
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = self.type.image
        return imageView
    }()

    private func setupSubviews() {
        [iconImageView, titleLabel].forEach(self.addSubview)
        iconImageView.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.centerY.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(11)
            $0.left.equalToSuperview().offset(16)
        }
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(iconImageView)
            $0.left.equalTo(iconImageView.snp.right).offset(16)
            $0.right.greaterThanOrEqualToSuperview().inset(10)
        }
    }
}
