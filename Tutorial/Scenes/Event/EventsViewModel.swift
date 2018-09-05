import Foundation
import RxCocoa
import RxSwift

final class EventsViewModel {

    private let useCase: EventsUseCase
    private let navigator: MainNavigator
    private let bag = DisposeBag()
    init(useCase: EventsUseCase, navigator: MainNavigator) {
        self.useCase = useCase
        self.navigator = navigator
    }

    private let elements = Variable<[Event]>([])
    private var page = 1
}

extension EventsViewModel {
    struct Input {
        let initTrigger: Driver<Void>
        let refreshTrigger: Driver<Void>
        let loadNextPageTrigger: Driver<Void>
        let modelSelected: Driver<Event>
    }

    struct Output {
        let refreshing: Driver<Bool>
        let loading: Driver<Bool>
        let events: Driver<[Event]>
        let isNavigated: Driver<Bool>
        let error: Driver<Error>
    }
}

extension EventsViewModel: ViewModelType {
    func transform(input: Input) -> Output {
        let refreshingActivityIndicator = ActivityIndicator()
        let loadingActivityIndicator = ActivityIndicator()
        let refreshing = refreshingActivityIndicator.asDriver()
        let loading = loadingActivityIndicator.asDriver()
        let errorTracker = ErrorTracker()
        let errors = errorTracker.asDriver()
        let refreshResponse = Driver.merge(input.initTrigger, input.refreshTrigger)
                .withLatestFrom(refreshing)
                .do(onNext: { _ in
                    self.elements.value = []
                    self.page = 1
                })
                .flatMapLatest { (_) -> Driver<[Event]> in
                    return self.request(
                            page: self.page,
                            activityIndicator: refreshingActivityIndicator,
                            errorTracker: errorTracker
                    )
                }
        // TODO: 次のページがなかった場合リクエストを止めるようにする
        let nextPageResponse = input.loadNextPageTrigger
                .withLatestFrom(loading)
                .filter { !$0 }
                .do(onNext: { _ in
                    self.page += 1
                })
                .flatMap { Void -> Driver<[Event]> in
                    return self.request(page: self.page,
                            activityIndicator: loadingActivityIndicator,
                            errorTracker: errorTracker)
                }
        let isNavigated = input.modelSelected
                .do(onNext: { model in
                    self.navigator.toRepository(repo: model.repo)
                })
                .map { _ in true }
        Driver
                .merge(refreshResponse, nextPageResponse)
                .drive(onNext: {
                    self.elements.value.append(contentsOf: $0)
                }).disposed(by: bag)

        return Output(refreshing: refreshing,
                loading: loading,
                events: elements.asDriver(),
                isNavigated: isNavigated,
                error: errors)
    }

    private func request(
            page: Int,
            activityIndicator: ActivityIndicator,
            errorTracker: ErrorTracker
    ) -> Driver<[Event]> {
        return useCase.events(page: page)
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .map { $0.data }
                .asDriver(onErrorJustReturn: [])
    }
}
