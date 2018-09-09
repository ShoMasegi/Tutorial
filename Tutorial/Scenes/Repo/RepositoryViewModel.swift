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
    private var element = Variable<Repository?>(nil)
}

extension RepositoryViewModel {
    struct Input {
        let apiUrl: URL?
        let initTrigger: Driver<Void>
    }

    struct Output {
        let repository: Driver<Repository?>
    }
}

extension RepositoryViewModel: ViewModelType {
    func transform(input: Input) -> Output {
        let refreshResponse = input.initTrigger
                .flatMapLatest { (_) -> Driver<Repository?> in
                    guard let url = input.apiUrl else {
                        return Driver.empty()
                    }
                    return self.useCase
                            .repository(apiUrl: url.absoluteString)
                            .map { $0.data }
                            .asDriver(onErrorJustReturn: nil)
                }
        refreshResponse
                .drive(onNext: {
                    self.element.value = $0
                }).disposed(by: bag)

        return Output(repository: element.asDriver())
    }
}
