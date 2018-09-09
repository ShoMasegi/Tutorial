import UIKit
import SnapKit
import Down

class ReadMeTableViewCell: UITableViewCell, Reusable {

    var readme: ReadMe? = nil {
        didSet {
            guard let readme = self.readme else { return }
            headerLabel.text = readme.name
            if let string = try? String(contentsOf: readme.downloadUrl, encoding: .utf8) {
                try? downView.update(markdownString: string) {}
            }
            downView.snp.updateConstraints {
                $0.height.equalTo(downViewSize)
            }
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.text = "README.md"
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    private lazy var headerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.t_border.cgColor
        return view
    }()
    private lazy var downView: DownView = {
        let string = "# README.md Does Not Exist"
        let view = try! DownView(frame: .zero, markdownString: string)
        return view
    }()
    private var downViewSize: CGFloat {
        let height = UIScreen.main.bounds.height - 70 - headerView.bounds.height
        if let readme = self.readme, readme.size > 200 {
            return height
        } else {
            return height / 2
        }
    }

    private func setupSubviews() {
        [iconImageView, headerLabel].forEach(headerView.addSubview)
        [headerView, downView].forEach(contentView.addSubview)
        iconImageView.snp.makeConstraints {
            $0.height.width.equalTo(18)
            $0.left.equalToSuperview().offset(18)
            $0.top.bottom.equalToSuperview().inset(9)
            $0.centerY.equalToSuperview()
        }
        headerLabel.snp.makeConstraints {
            $0.left.equalTo(iconImageView.snp.right).offset(16)
            $0.right.greaterThanOrEqualToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        headerView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
        downView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(headerView.snp.bottom)
            $0.height.equalTo(downViewSize)
        }
    }
}
