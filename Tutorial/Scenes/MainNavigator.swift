import UIKit

final class MainNavigator {

    private let provider: UseCaseProvider
    private weak var navigationController: UINavigationController?

    init(provider: UseCaseProvider,
         navigationController: UINavigationController?) {
        self.provider = provider
        self.navigationController = navigationController
    }

    func toRoot() {
        let viewModel = EventsViewModel(useCase: provider.makeEventsUseCase(), navigator: self)
        let viewController = EventsViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: false)
    }

    func toRepository(repo: Repository) {
        let viewController = RepositoryViewController(
                viewModel: RepositoryViewModel(useCase: provider.makeRepositoryUseCase(),
                                               navigator: self),
                repo: repo)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
