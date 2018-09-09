import UIKit
import SnapKit
import RxSwift
import RxCocoa

class RepositoryViewController: UIViewController {

    private let viewModel: RepositoryViewModel
    private var repo: Repository?
    private let bag = DisposeBag()

    init(viewModel: RepositoryViewModel, repo: Repository) {
        self.viewModel = viewModel
        self.repo = repo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = repo?.name
        self.setupSubviews()
    }

    private enum SectionType {
        case cover, info, readme
    }
    
    private let sections: [SectionType] = [.cover, .info, .readme]

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = .white
        tableView.separatorColor = .clear
        tableView.allowsSelection = false
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
        output.repository.drive(onNext: { [weak self] repository in
            guard let `self` = self else { return }
            self.title = repository?.name
            self.repo = repository
        }).disposed(by: bag)
    }
}

}
