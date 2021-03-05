import Domain
import Foundation
import RxSwift
import RxCocoa

final class RepositoryViewModel {
    private let useCase: RepositoryUseCase
    private let navigator: MainNavigator

    init(useCase: RepositoryUseCase, navigator: MainNavigator) {
        self.useCase = useCase
        self.navigator = navigator
    }
}

extension RepositoryViewModel {
    struct Input {
        let apiUrl: URL?
        let initTrigger: Driver<Void>
    }

    struct Output {
        let data: Driver<(Repository, ReadMe?)>
        let loading: Driver<Bool>
    }
}

extension RepositoryViewModel: ViewModelType {
    func transform(input: Input) -> Output {
        let loadingActivityIndicator = ActivityIndicator()
        let loading = loadingActivityIndicator.asDriver()
        let dataResponse = input.initTrigger
            .flatMapLatest { (_) -> Driver<Repository> in
                guard let url = input.apiUrl else { return Driver.empty() }
                return self.useCase
                    .repository(apiUrl: url.absoluteString)
                    .map { Repository(with: $0) }
                    .asDriverOnErrorJustComplete()
            }
            .flatMapLatest { repository -> Driver<(Repository, ReadMe?)> in
                guard let owner = repository.owner else { return Driver.empty() }
                return self.useCase
                    .readme(owner: owner.login, repo: repository.name)
                    .map { (repository, ReadMe(with: $0)) }
                    .trackActivity(loadingActivityIndicator)
                    .asDriver(onErrorJustReturn: (repository, nil))
            }
        return Output(data: dataResponse, loading: loading)
    }
}
