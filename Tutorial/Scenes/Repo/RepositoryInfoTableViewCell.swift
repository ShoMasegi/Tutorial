import UIKit
import SnapKit

class RepositoryInfoTableViewCell: UITableViewCell, Reusable {

    var repo: Repository? {
        didSet {
            guard let repo = self.repo else { return }
            accessCell.type = .access(isPrivate: repo.isPrivate)
            languageCell.type = .lang(language: repo.language)
            issuesCell.type = .issue(count: repo.openIssuesCount)
            dateCell.type = .date(date: repo.updatedAt)
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()
    private lazy var firstRow: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()
    private lazy var secondRow: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()
    private lazy var accessCell = ImageLabelCell(type: .access(isPrivate: nil))
    private lazy var languageCell = ImageLabelCell(type: .lang(language: nil))
    private lazy var issuesCell = ImageLabelCell(type: .issue(count: nil))
    private lazy var dateCell = ImageLabelCell(type: .date(date: nil))

    private func setupSubviews() {
        [accessCell, languageCell].forEach(firstRow.addArrangedSubview)
        [issuesCell, dateCell].forEach(secondRow.addArrangedSubview)
        [firstRow, secondRow].forEach(stackView.addArrangedSubview)
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
