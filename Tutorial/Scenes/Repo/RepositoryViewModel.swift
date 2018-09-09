import Foundation
import RxSwift
import RxCocoa

final class RepositoryViewModel {
    private let useCase: RepositoryUseCase
    private let navigator: MainNavigator
    private let bag = DisposeBag()

    init(useCase: RepositoryUseCase, navigator: MainNavigator) {
        self.useCase = useCase
        self.navigator = navigator
    }
    private var repoElement = Variable<Repository?>(nil)
    private var readElement = Variable<ReadMe?>(nil)
}

extension RepositoryViewModel {
    struct Input {
        let apiUrl: URL?
        let initTrigger: Driver<Void>
    }

    struct Output {
        let repository: Driver<Repository?>
        let readme: Driver<ReadMe?>
    }
}

extension RepositoryViewModel: ViewModelType {
    func transform(input: Input) -> Output {
        let repoResponse = input.initTrigger
                .flatMapLatest { (_) -> Driver<Repository?> in
                    guard let url = input.apiUrl else {
                        return Driver.empty()
                    }
            return self.useCase
                    .repository(apiUrl: url.absoluteString)
                    .map { $0.data }
                    .asDriver(onErrorJustReturn: nil)
        }
        repoResponse
                .drive(onNext: {
                    self.repoElement.value = $0
                }).disposed(by: bag)
        let readResponse = repoResponse.asDriver()
                .map { $0 }
                .flatMapLatest { repository -> Driver<ReadMe?> in
                    guard let repository = repository,
                          let owner = repository.owner else {
                        return Driver.empty()
                    }
                    return self.useCase
                            .readme(owner: owner.login, repo: repository.name)
                            .map { $0.data }
                            .asDriver(onErrorJustReturn: nil)
                }
        readResponse
                .drive(onNext: {
                    self.readElement.value = $0
                }).disposed(by: bag)
        return Output(repository: repoElement.asDriver(), readme: readElement.asDriver())
    }
}
