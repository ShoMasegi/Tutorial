import UIKit
import RxCocoa
import RxSwift
import SnapKit

class EventsViewController: UIViewController {

    private let viewModel: EventsViewModel
    private let bag = DisposeBag()

    init(viewModel: EventsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = titleLabel
        setupSubviews()
        bind()
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.text = "Event"
        label.textColor = .white
        label.font = UIFont(name: "Menlo-Bold", size: 17)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapTitleView(_:)))
        label.addGestureRecognizer(gesture)
        return label
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .white
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        tableView.separatorColor = .lightGray
        tableView.refreshControl = refreshControl
        tableView.tableFooterView = UIView()
        tableView.register(EventTableViewCell.self)
        return tableView
    }()
    private let refreshControl = UIRefreshControl()

    private func setupSubviews() {
        [tableView].forEach(view.addSubview)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func bind() {
        let trigger: PublishSubject<Void> = PublishSubject<Void>()
        defer { trigger.onNext(()) }
        let initTrigger = trigger.asDriver(onErrorJustReturn: ())
        let refreshTrigger = refreshControl.rx.controlEvent(.valueChanged).asDriver()
        let loadNextPageTrigger = tableView.rx.reachedBottom
                .asDriverOnErrorJustComplete()
        let input = EventsViewModel.Input(
                initTrigger:  initTrigger,
                refreshTrigger: refreshTrigger,
                loadNextPageTrigger: loadNextPageTrigger,
                modelSelected: tableView.rx.modelSelected(Event.self).asDriver()
        )
        let output = viewModel.transform(input: input)
        output.events.drive(tableView.rx.items(cellIdentifier: EventTableViewCell.reuseIdentifier, cellType: EventTableViewCell.self)) { _, element, cell in
            cell.event = element
        }.disposed(by: bag)
        output.refreshing.drive(onNext: { [weak self] fetching in
            guard let `self` = self else { return }
            if fetching {
                self.refreshControl.beginRefreshing()
            } else {
                self.refreshControl.endRefreshing()
            }
        }).disposed(by: bag)
        output.isNavigated.drive().disposed(by: bag)
        output.error.drive(onNext: { error in
            if let apiError = error as? APIError {
                self.presentAlert(title: "Error", message: apiError.message)
            } else {
                print(error.localizedDescription)
            }
        }).disposed(by: bag)
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let `self` = self else { return }
            self.tableView.deselectRow(at: indexPath, animated: true)
        }).disposed(by: bag)
    }

    @objc private func tapTitleView(_: UIGestureRecognizer) {
        self.tableView.scrollToTop(animated: true)
    }
}
