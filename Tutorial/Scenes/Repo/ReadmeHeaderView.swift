import UIKit
import SnapKit

class ReadmeHeaderView: UITableViewHeaderFooterView, Reusable {

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .white
        self.contentView.layer.borderColor = UIColor.t_border.cgColor
        self.contentView.layer.borderWidth = 0.5
        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "readme")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.text = "README.md"
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()

    private func setupSubviews() {
        [iconImageView, label].forEach(contentView.addSubview)
        iconImageView.snp.makeConstraints {
            $0.height.width.equalTo(18)
            $0.left.equalToSuperview().offset(18)
            $0.top.bottom.equalToSuperview().inset(9)
        }
        label.snp.makeConstraints {
            $0.left.equalTo(iconImageView.snp.right).offset(16)
            $0.right.greaterThanOrEqualToSuperview().inset(10)
            $0.centerY.equalTo(iconImageView)
        }
    }
}
