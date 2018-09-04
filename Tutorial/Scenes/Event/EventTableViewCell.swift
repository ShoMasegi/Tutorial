import UIKit
import SnapKit
import Nuke

class EventTableViewCell: UITableViewCell, Reusable {

    var event: Event? {
        didSet {
            guard let event = event else { return }
            Nuke.loadImage(with: event.actor.avatarUrl, into: iconImageView)
            eventLabel.text = event.type
            repoLabel.text = event.repo.name
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutIfNeeded()
        iconImageView.layer.cornerRadius = iconImageView.frame.height / 2
    }

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    private lazy var eventLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    private lazy var repoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14)
        return label
    }()

    private func setupSubviews() {
        [iconImageView, eventLabel, repoLabel].forEach(contentView.addSubview)
        iconImageView.snp.makeConstraints {
            $0.height.width.equalTo(40)
            $0.top.left.equalToSuperview().inset(16)
        }
        eventLabel.snp.makeConstraints {
            $0.left.equalTo(iconImageView.snp.right).offset(16)
            $0.right.lessThanOrEqualToSuperview().offset(-24)
            $0.top.equalTo(iconImageView).offset(2)
        }
        repoLabel.snp.makeConstraints {
            $0.left.equalTo(iconImageView.snp.right).offset(16)
            $0.right.equalToSuperview().inset(24)
            $0.top.equalTo(eventLabel.snp.bottom).offset(2)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
}
