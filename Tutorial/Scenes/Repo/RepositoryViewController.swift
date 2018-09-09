import UIKit
import SnapKit
import RxSwift
import RxCocoa

class RepositoryViewController: UIViewController {

    private let viewModel: RepositoryViewModel
    private var repo: Repository?
    private var readme: ReadMe?
    private let bag = DisposeBag()

    init(viewModel: RepositoryViewModel, repo: Repository) {
        self.viewModel = viewModel
        self.repo = repo
        super.init(nibName: nil, bundle: nil)
        hideBackButtonTitle()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = repo?.name
        self.setupSubviews()
        self.bind()
    }

    private enum SectionType {
        case cover, info, readme
    }
    
    private let sections: [SectionType] = [.cover, .info, .readme]

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorColor = .clear
        tableView.allowsSelection = false
        tableView.backgroundColor = .white
        tableView.bounces = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UserCoverTableViewCell.self)
        tableView.register(RepositoryInfoTableViewCell.self)
        tableView.register(ReadMeTableViewCell.self)
        return tableView
    }()

    private func setupSubviews() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func bind() {
        let trigger: PublishSubject<Void> = PublishSubject<Void>()
        defer { trigger.onNext(()) }
        let initTrigger = trigger.asDriver(onErrorJustReturn: ())
        let input = RepositoryViewModel.Input(
                apiUrl: repo?.url,
                initTrigger: initTrigger
        )
        let output = viewModel.transform(input: input)
        Driver
                .zip(output.repository, output.readme)
                .drive(onNext: { [weak self] (repository, readme) in
                    guard let `self` = self else { return }
                    self.title = repository?.name
                    self.repo = repository
                    self.readme = readme
                    self.tableView.reloadData()
                }).disposed(by: bag)
    }
}

extension RepositoryViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .cover:
            let cell: UserCoverTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.repo = self.repo
            return cell
        case .info:
            let cell: RepositoryInfoTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.repo = self.repo
            return cell
        case .readme:
            let cell: ReadMeTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.readme = self.readme
            return cell
        }
    }
}

extension RepositoryViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch self.sections[section] {
        case .cover, .info: return 12
        default: return .leastNonzeroMagnitude
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch self.sections[section] {
        case .cover, .info:
            let view = UIView()
            view.backgroundColor = UIColor(hex: "F8F8F8")
            return view
        default: return nil
        }
    }
}
