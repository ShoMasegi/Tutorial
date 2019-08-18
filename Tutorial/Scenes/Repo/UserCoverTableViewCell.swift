import UIKit
import SnapKit
import Nuke

class UserCoverTableViewCell: UITableViewCell, Reusable {

    var repo: Repository? {
        didSet {
            guard let repo = self.repo else { return }
            if let owner = repo.owner {
                Nuke.loadImage(with: owner.avatarUrl, into: iconImageView)
                userNameLabel.text = owner.login
            }
            descriptionLabel.text = repo.description ?? "No description"
            starCell.type = .star(count: repo.stargazersCount ?? 0)
            watchCell.type = .watch(count: repo.watchersCount ?? 0)
            forkCell.type = .fork(count: repo.forksCount ?? 0)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        coverView.layoutIfNeeded()
        iconImageView.layer.cornerRadius = iconImageView.frame.height / 2
    }

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Username"
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "description of this repository"
        label.textColor = UIColor(hex: "FFFFFF", alpha: 0.7)
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    private lazy var coverView: UIView = {
        let view = UIView()
        view.backgroundColor = .t_grey
        return view
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()
    private lazy var starCell = RepositoryInfoCell(type: .star(count: 0))
    private lazy var watchCell = RepositoryInfoCell(type: .watch(count: 0))
    private lazy var forkCell = RepositoryInfoCell(type: .fork(count: 0))

    private func setupSubviews() {
        [starCell, watchCell, forkCell].forEach(stackView.addArrangedSubview)
        [iconImageView, userNameLabel, descriptionLabel].forEach(coverView.addSubview)
        [coverView, stackView].forEach(contentView.addSubview)
        iconImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(32)
            $0.height.width.equalTo(80)
        }
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.bottom).offset(7)
            $0.centerX.equalToSuperview()
            $0.left.greaterThanOrEqualToSuperview().offset(30)
            $0.right.lessThanOrEqualToSuperview().offset(-30)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(4)
            $0.bottom.equalToSuperview().inset(28)
            $0.centerX.equalToSuperview()
            $0.left.greaterThanOrEqualToSuperview().offset(30)
            $0.right.lessThanOrEqualToSuperview().offset(-30)
        }
        coverView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
        stackView.snp.makeConstraints {
            $0.top.equalTo(coverView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}
