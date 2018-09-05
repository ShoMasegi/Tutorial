import UIKit
import SnapKit

class RepositoryViewController: UIViewController {

    private let viewModel: RepositoryViewModel
    private let repo: Repository

    init(viewModel: RepositoryViewModel, repo: Repository) {
        self.viewModel = viewModel
        self.repo = repo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = repo.name
        self.setupSubviews()
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = .white
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = .lightGray
        tableView.tableFooterView = UIView()
        return tableView
    }()

    private func setupSubviews() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
